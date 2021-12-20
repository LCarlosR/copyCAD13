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
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - FUNCTIONS - STARTS -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
Function iniFecha ($dias) {
    [dateTime]$fechaActTemp = (Get-date).AddDays(-$dias)
    $fechaAct = $fechaActTemp
    $fechaAct = $fechaAct.addHours(-($fechaActTemp).Hour)
    $fechaAct = $fechaAct.addMinutes(-($fechaActTemp).Minute)
    $fechaAct = $fechaAct.addSeconds(-($fechaActTemp).Second)
    return $fechaAct
}
# Validamos que exista el fichero de datos
Function verificarOrigen ($salIn) {
    $codSalida = 0
    if ( Test-Path $salIn ) {  # Existe el fichero de configuración
            write-log -Text "Existe: $salIn" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "0.-Check-File" 
    } else { # No Existe el fichero de configuración abortamos
            write-log -Text "Abortamos NO existe: $salIn" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "0.-Check-File-Error" 
            $codSalida = 1
    }
    return $codSalida
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
Function filesMod ($directorio, $fechaDesde) { 
    $resMod = Get-ChildItem -Recurse $directorio -File | Where-Object { $_.LastWriteTime -gt $fechaDesde }
return $resMod.FullName
}
#
# Copiamos ficheros del origen al destinoS, constrimos path y llamamos a la finción "copiamos"
#
Function aCopiar ($aOri, $aDest, $xDonde) { 
    foreach ($a in $aOri) {
        $b = $a -split($xDonde)
        $c = $aDest + $b[1]
        $retorno = copiamos $a $c
        write-host "$retorno - $a   ---- $c "
        if ($retorno -ne 0) {
            write-log -Text "No se ha podido copiar: $outEco" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "3.-Check-File-Error" 
        }
    }
}
#
Function copiamos ($fileOri, $fileDest) { 
    $codSalida = 0
    try {
        Copy-Item -Path $fileOri -Destination $fileDest -Recurse -Force -EA stop
            $texto = "Copiamos el objeto origen: $fileOri al destino: $fileDest"
            write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "1.- Copia datos "
    } catch [System.ArgumentException] {
        $codSalida = 1
        # write-host $Error.FullyQualifiedErrorId 
    } catch {
        $codSalida = 1
        # write-host $Error.FullyQualifiedErrorId 
    }    
    return $codSalida
}
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - VARIABLES - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
    # [string]$anoEnCurso = (Get-date).Year
    # El dígito representa el número de dias a barrer hacia atras. 0 -> Hoy a las 00:00:00, 3 -> desde hace 3 días a las 00:00:00
        [dateTime]$fechaAct = iniFecha 1   
    # $fechaActAll = (Get-date).AddDays(-5000)
    $LogNamePre = "LOG-COPIA-"
    $prefijo    = "D:\miData\Hostalia\bankiaAD"
    $logDIR     = $prefijo + "\LOG\"
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
    # Verificamos si están los datos del mes y año, en curso ambos
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
    # Copiamos solo los ficheros actualizazos hoy, si quermos todos utilizar $fechaActAll
    $filesRaizXamp = "H:\xampp\htdocs\web\bankiaAD"
    $filesRaizDelimitador = "bankiaAD"
    $filesEco = filesMod $inEco $fechaAct
    if ($filesEco.length -gt 0) {
        write-host $filesEco
        aCopiar $filesEco $filesRaizXamp $filesRaizDelimitador
    }
    write-log -Text "*********** FIN LOG ******** " -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "*************** FIN **************"  