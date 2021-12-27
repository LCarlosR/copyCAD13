#**************************************************************************************************************************************************
#*      Fichero:  C:\miData\Hostalia\bankiaAD\scripts\copiaADestinos.ps1                              
#*        Autor:  Carlos Ruiz                                                           
#*      Version:  1.0                                                                   
#* Fecha inicio:  02/11/2021                                                                                                                        
#*     Objetivo:  copia ficheros de datos económicos a destino desde:
#*
#*                copia de ficheros: MANUALMENTE, por su bajo índice de actualización
#*                   D:\miData\Hostalia\bankiaAD\HTML\css\             manual           ( de aqui *.css )
#*                   D:\miData\Hostalia\bankiaAD\HTML\icon\            manual           ( de aqui todo lo que cuelga )
#*                   D:\miData\Hostalia\bankiaAD\HTML\images\          manual           ( de aqui todo lo que cuelga )
#*
#*                copia ficheros de datos y fuentes a web a la nube test y producción desde:
#*                   Origen -> D:\miData\Hostalia\bankiaAD\HTML\                                  ( de aquí *.html)
#*                          Destino ==> C:\WEB\bankiaAD\HTML\                                     ( en desuso)
#*                          Destino ==> H:\xampp\htdocs\web\bankiaAD\HTML\
#*                   Origen -> D:\miData\Hostalia\bankiaAD\HTML\src\                              ( de aqui *.js, *.php )
#*                          Destino ==> C:\WEB\bankiaAD\HTML\src\                                 ( en desuso)
#*                          Destino ==> H:\xampp\htdocs\web\bankiaAD\HTML\src\
#*                   Origen -> D:\miData\Hostalia\bankiaAD\HTML\salida\                           ( de aqui toda la estructura que cuelga )
#*                          Destino ==> C:\WEB\bankiaAD\HTML\salida\                              ( en desuso)
#*                          Destino ==> H:\xampp\htdocs\web\bankiaAD\HTML\salida
#*
#* Para pasar a la nube lo hacemos manualmente a través de un cliente FTP
#*
#**************************************************************************************************************************************************
#
#**************************************************************************************************************************************************
# -   PARÁMETROS IN    -
#**************************************************************************************************************************************************
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# -   IMPORT MODULES   -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
Import-Module D:\data\PS\TOOLS\write-Log.psm1
Import-Module D:\miData\Hostalia\bankiaAD\scripts\IG-01.psm1
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - FUNCTIONS - STARTS -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
function selDirectorio ($unidad, $desc) {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = $unidad
    $browse.ShowNewFolderButton = $false
    $browse.Description = $desc
    $loop = $true
    while($loop) {
        if ($browse.ShowDialog() -eq "OK") {
            $loop = $false 
        } else {
            $res = [System.Windows.Forms.MessageBox]::Show("Has tecleado cancelar. Deseas reintentarlo o salir?", "Elija un directorio", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if ($res -eq "Cancel") {
                return "NoSel"      #Ends script
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}
Function iniFecha ($dias) { # Pone na fecha del parámetro MM/DD/YYYY HH:MM a MM/DD/YYYY 00:00:00
    [dateTime]$fechaActTemp = (Get-date).AddDays(-$dias)
    $fechaAct = $fechaActTemp
    $fechaAct = $fechaAct.addHours(-($fechaActTemp).Hour)
    $fechaAct = $fechaAct.addMinutes(-($fechaActTemp).Minute)
    $fechaAct = $fechaAct.addSeconds(-($fechaActTemp).Second)
    return $fechaAct
}
#
Function verificarObjeto ($salOut, $crearSalida) { 
    # Validamos que exista el objeto $salOut. Sí no existe, lo creamos sí $crearSalida -eq 1
    $codSalida = 0
    if ( Test-Path $salOut ) {  # Existe el directorio de salida
         write-log -Text "Existe el objeto:  $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "2.-Check-File" 
    } else {                    # No Existe  el directorio de salida, lo creamos
        if ( $crearSalida -eq 1) {
            write-log -Text " NO existe el objeto: $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "2.-Check-File-Error" 
            try {
                New-Item -Path $salOut -ItemType Directory -EA Stop
                write-log -Text "Creamos el objeto:  $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "2.-Check-File" 
            } catch {
                write-host $error[0].Exception.GetType().FullName
                $codSalida = 1
            }
        } else {
            write-log -Text " NO existe el direcorio de salida, NO lo creamos: $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "2.-Check-File-Error" 
        }
    }
    return $codSalida 
}
#
# Solo seleccionamos los ficheros modificados, no directorios despues de $fechaDesde
Function haySalida ($numFiles, $rutaDest) { 
    if ($numFiles.count -gt 0) {
        foreach ($a in $numFiles) {
            $retorno = copiamos $a $rutaDest
            if ($retorno -ne 0) {
                write-log -Text "No se ha podido copiar: $outEco" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "1.1- Copia File-Error" 
            }
        } 
    } else {    
        write-log -Text "Finalizamos, NO hay ficheros modificados: $inEco" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Ficheros modificados" 
    }
}
#
Function copiamos ($fileOri, $fileDest) { 
    $codSalida = 0

    try {
        Copy-Item -Path $fileOri.fullName -Destination $fileDest -Recurse -Force -EA stop
            $texto = "Copiamos el objeto origen: $fileOri al destino: $fileDest"
            write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "1.- Copia datos "
    } catch [System.ArgumentException] {
        $codSalida = 1
        write-host $Error.FullyQualifiedErrorId 
    } catch [System.IO.FileNotFoundException] {
        $codSalida = 1
        write-host $Error.FullyQualifiedErrorId     
    } catch [System.IO.IOException] {
        $codSalida = 1
        write-host $Error.FullyQualifiedErrorId     
    } catch [Microsoft.PowerShell.Commands.CopyItemCommand] {
        $codSalida = 1
        write-host $Error.FullyQualifiedErrorId  
    } catch {
        $codSalida = 1
        write-host $Error.FullyQualifiedErrorId 
    }    
    return $codSalida
}
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - VARIABLES - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
    $LogNamePre    = "LOG-COPIA-"
    $prefijo       = "D:\miData\Hostalia\bankiaAD"
    $logDIR        = $prefijo + "\LOG\"
    #
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    # - Ficheros de CODIGO FUENTE HTML -
    #*           Origen  --> D:\miData\Hostalia\bankiaAD\HTML\         (directorio de desarrollo)
    #*           Destino ==> H:\xampp\htdocs\web\bankiaAD\HTML\        (directorio del servidor WEB)
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    #
    write-log -Text "----------- Nuevo LOG ------- " -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "--------- Iniciamos"      
    [string]$inEco   = "D:\miData\Hostalia\bankiaAD\HTML\"
    [string]$outEco  = "H:\xampp\htdocs\web\bankiaAD\HTML\"
    # [string]$outEco  = "C:\web\"
    # Asignamos el directorio origen (no modificable en el formulario)
    <#
        $outEco = selDirectorio $outEco "Directorio por defecto: $outEco"
        if ($outEco -eq "NoSel") {
            $texto="Error: No se ha seleccionado ningún directorio cancelamos el proceso"
            write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
            exit 0
        }
    #>
    # $data tiene la estructura: # 1: HTML (default) # 2: SRC # 3: CSS # 4: Salida # 5: Listador # 6: Todo  
    # El dígito representa el número de dias a barrer hacia atras. 0 -> Hoy a las 00:00:00, 3 -> desde hace 3 días a las 00:00:00
        # [0] directorio origen fijado, si trae un "0" cancelamos el proceso
        # [1] directorio de destino seleccionado
        # [2] fecha y hora desse la que vamos a buscarlos ficheros a copiar en el formato "MM/DD/YYYY 00:00:00" 
        # [3] opción seleccionada rango [1-6]
    # llamamos al formulario de seleción de datos
    $data = obtieneDatos $inEco $outEco  
    if ($Data[0] -eq "0") {
        $texto="Proceso cancelado por el usuario"
        write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
        exit 0
    }
    [string]$miOpcion = $data[3]
    # Verificamos  sí existe el directorio de origen, si no abortamos
    $retorno = verificarObjeto $inEco 0
    if ($retorno -ne 0) {
        write-log -Text "Abortamos NO existe: $inEco" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "4.-Check-File-Error" 
        exit 0
    }
    # Verificamos si existe el directorio de destino, si no existe los creamos, si falla la creación abortamos
    $retorno = verificarObjeto $outEco 1
    if ($retorno -ne 0) {
        write-log -Text "Abortamos NO existe: $outEco" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "5.-Check-File-Error" 
        exit 0
    }
    # Copiamos Según las opciones
    # Copiamos solo los ficheros actualizazos hoy, si queremos todos utilizar $fechaActAll

    if ($filesEco.length -gt 0) {
        write-log -Text "Finalizamos NO hay ficheros modificados: $inEco" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "4.-Check-File-Error" 
    }
    
#-----------------------------------------------------------------------------------------------------------------------------------------------------
foreach ($x in $data) {
    write-host $x
}
# 1: HTML (default) # 2: SRC # 3: CSS # 4: Salida # 5: Listado # 6: Todo  

    # El dígito representa el número de dias a barrer hacia atras. 0 -> Hoy a las 00:00:00, 3 -> desde hace 3 días a las 00:00:00
    # La fecha devuelta en $data[2] está en el formato "MM/DD/YYYY 00:00:00", la utilizamos para ver los ficheros actualizados desde esa fecha y hora.
    #
    switch ($miOpcion) {
        "1" # copiamos los *.html que hay en el raiz a destino
        {
            $filesEco = Get-ChildItem -Force -File -path $inEco  | Where-Object -FilterScript { $_.LastWriteTime -gt $data[2] -and ($_.name -like '*.html') }
        }
        "2" # copiamos los *.php y *.js
        {
            $filesEco = Get-ChildItem -Force -Recurse -File -path $inEco  | Where-Object -FilterScript { $_.LastWriteTime -gt $data[2] -and (($_.name -like '*.php') -or ($_.name -like '*.js')) }
        }
        "3" # copiamos los *.css
        {
            $filesEco = Get-ChildItem -Force -Recurse -File -path $inEco  | Where-Object -FilterScript { $_.LastWriteTime -gt $data[2] -and ($_.name -like '*.css') }
        }
        "4" # copiamos lo actualizado en el directorio "salida" con extensión pdf, gif, html, jpg
        {
            $filesEco = Get-ChildItem -Force -Recurse -File -path $inEco  | Where-Object -FilterScript { $_.LastWriteTime -gt $data[2] -and (($_.name -like '*.pdf') -or ($_.name -like '*.gif') -or ($_.name -like '*.html') -or ($_.name -like '*.jpg')) }
        }
        "5" # creamos un listado con los objetos a modificar de extensión: php, js, pdf, gif, html, jpg
        {   # Get-ChildItem -Path $env:ProgramFiles -Recurse -Include *.exe | Where-Object -FilterScript {($_.LastWriteTime -gt '2005-10-01') -and ($_.Length -ge 1mb) -and ($_.Length -le 10mb)}
            $filesEco = Get-ChildItem -Force -Recurse -File -path $inEco  | Where-Object -FilterScript { $_.LastWriteTime -gt $data[2] }    
            # $sal | Out-GridView
        }
        "6" # copiamos todo lo anterior copciones de [1-4], es decir, el resultado de la opción 5 de extensión: php, js, pdf, gif, html, jpg
        {
            $filesEco = Get-ChildItem -Force -Recurse -File -path $inEco  | Where-Object -FilterScript { $_.LastWriteTime -gt $data[2] }
        }
    }
    if ($miOpcion -ne "5") {
        haySalida $filesEco $outEco
    }
    $filesEco |  Format-table -property LastWriteTime, FullName
    write-log -Text "*********** FIN LOG ******** " -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "*************** FIN **************"  
