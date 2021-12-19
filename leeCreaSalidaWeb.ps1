#**************************************************************************************************************************************************
#*      Fichero:  C:\miData\Hostalia\bankiaAD\scripts\leeCreaSalidaWeb.ps1                              
#*        Autor:  Carlos Ruiz                                                           
#*      Version:  1.0                                                                   
#* Fecha inicio:  18/09/2020                                                                                                                        
#*     Objetivo:  Lee un ficheo de BK en CSV y genera un HTML con los datos de un mes en concreto
#* Parámetros IN: nombre del fichero de entrada default "datosMBK21.csv"  
#*
#* Fecha modif.:  06/01/2021                                                           
#*     Objetivo:  Generar todos los ficheros "mes a mes" y el anual con el nombre "sheetYY13.html"
#*Parámetros IN:  Nombre del fichero de datos (default):  "datosMBK21.csv", mejor de datosMBKAll.csv
#*                Lo cogerá de -> D:\miData\Hostalia\bankiaAD\filesMov
#*                Pondremos el correspondiente al año, o diferentes años ordenamos de mayor a menor por año y dentro del año por mes y día
#*                Por defecto tomará el año en curso, como string
#*       Salida:  D:\miData\Hostalia\bankiaAD\salida\YYYY
#*                         
#**************************************************************************************************************************************************
#
#**************************************************************************************************************************************************
# -   PARÁMETROS IN    -
#**************************************************************************************************************************************************
    Param ( 
        [string]$nameFileIn   = "datosMBKAll.csv"
        # [string]$anoDH = (Get-date).Year 
    )
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
Function f_Head ($rutaHTML) { 
    "<html>"                                                                                                                 | Out-File "$rutaHTML" -Encoding            UTF8
    "   <head>"                                                                                                              | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "       <meta name=`"robots`" content=`"noindex`" />"                                                                    | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "       <link rel=`"Stylesheet`" href=`"css/estilosHojaTabla1.css`" />"                                                  | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   </head>"                                                                                                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
}
#
Function f_IniBody ($rutaHTML, $t) { 
    "   <body link=`"#0563C1`" vlink=`"#954F72`">"                                                                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "       <table class=`"tabla1`">"                                                                                        | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "           <caption>$t</caption>"                                                                                       | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "           <thead>"                                                                                                     | Out-File "$rutaHTML" -Append  -Encoding   UTF8      
}
#
# FECHA;FEC. VALOR;DESCRIPCION;IMPORTE;DIV.;SALDO;DIV.;CATEGORÍA;CONCEPTO 2;CONCEPTO 3;CONCEPTO 4;CONCEPTO 5;CONCEPTO 6;CONCEPTO 7
# FECHA            DESCRIPCION IMPORTE      SALDO                CONCEPTO 2 CONCEPTO 3 CONCEPTO 4 CONCEPTO 5 CONCEPTO 6 CONCEPTO 7
# $dt0,            $dt2,       $dt3,        $dt5,                $dt8,      $dt9,      $dt10,     $dt11,     $dt12,     $dt13,     $dt14
# f_detalle $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5] $arrDat[8] $arrDat[9] $arrDat[10] $arrDat[11] $arrDat[12] $arrDat[13] $arrDat[14]  
Function f_CabeceraTab ($dt0, $dt2, $dt3, $dt5, $dt8, $dt9, $dt11, $dt12, $dt13, $rutaHTML) {
    "               <tr>"                                                                                                    | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh1`">$dt0</th>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh2`">$dt2</th>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh3`">$dt3</th>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh4`">$dt5</th>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh5`">$dt8</th>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh6`">$dt9</th>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh7`">$dt11</th>"                                                                        | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh8`">$dt12</th>"                                                                        | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                   <th class=`"xh9`">$dt13</th>"                                                                        | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "               </tr>"                                                                                                   | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "           </thead>"                                                                                                    | Out-File "$rutaHTML" -Append  -Encoding   UTF8 
    "           <tbody>"                                                                                                     | Out-File "$rutaHTML" -Append  -Encoding   UTF8      
}
#
Function f_Detalle ($dt0, $dt2, $dt3, $dt5, $dt8, $dt9, $dt11, $dt12, $dt13, $rutaHTML) {
    "               <tr>"                                                                                                    | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd1`">$dt0</td>"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd2`">$dt2</td>"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd3`">$dt3</td>"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd4`">$dt5</td>"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd5`">$dt8</td>"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd6`">$dt9</td>"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd7`">$dt11</td>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd8`">$dt12</td>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "                  <td class=`"xd9`">$dt13</td>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "               </tr>"                                                                                                   | Out-File "$rutaHTML" -Append  -Encoding   UTF8
}
#
Function f_FinBody ($rutaHTML) { 
    "           <tbody>"                                                                                                      | Out-File "$rutaHTML" -Append   -Encoding   UTF8      
    "       </table>"                                                                                                         | Out-File "$rutaHTML" -Append   -Encoding   UTF8
    "   </body>"                                                                                                              | Out-File "$rutaHTML" -Append   -Encoding   UTF8
    "</html>"                                                                                                                 | Out-File "$rutaHTML" -Append   -Encoding   UTF8
}
#
Function verificarSalida ($salOut) { 
#
    # Validamos que exista el directorio de salida de los htm. Sí no existe lo creamos
    if ( Test-Path $salOut ) {  # Existe el directorio de salida
         write-log -Text "Existe el directorio:  $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File" 
    } else {                    # No Existe  el directorio de salida, lo creamos
         write-log -Text " NO existe el direcorio de salida: $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File-Error" 
         try {
              New-Item -Path $salOut -ItemType Directory -EA Stop
              write-log -Text "Creamos el directorio:  $salOut" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File" 
         } catch {
              write-host $error[0].Exception.GetType().FullName
         }
    }
    <# 
    if ( Test-Path "$salOut\stylesheet.css" ) {  # Existe el directorio de estilo
         write-log -Text "Existe el fichero: $salOut\stylesheet.css" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File" 
    } else {
         write-log -Text "NO existe el fichero: $salOut\stylesheet.css lo copiamo" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File" 
         Copy-Item -Path "$prefijo\SALIDA\stylesheet.css" -Destination $salOut    
    }
    #>
}
#
Function daMesDe2 ([string]$md) { 
    if ($md.length -lt 2) {
         $md = "0" + $md
    }
    return $md
}
#
Function calTexto ($iMes) { 
    [string]$tRes
    switch ($iMes) {
         1 { $tRes = "Enero" }
         2 { $tres = "Febrero" }
         3 { $tres = "Marzo" }
         4 { $tres = "Abril" }
         5 { $tres = "Mayo" }
         6 { $tres = "Junio" }
         7 { $tres = "Julio" }
         8 { $tres = "Agosto" }
         9 { $tres = "Septiembre" }
        10 { $tres = "Octobre" }
        11 { $tres = "Noviembre" }
        12 { $tres = "Diciembre" }
        13 { $tres = "Año" } 
        Default { $tres = "Error" }
    }
    return $tRes
}
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - VARIABLES - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
    $LogNamePre = "LOG-MBK-"
    $prefijo    = "D:\miData\Hostalia\bankiaAD\"
    $logDIR     = $prefijo + "LOG\"
    $fileIn     = $prefijo + "filesMov\$nameFileIn"            # Ruta dónde está el fichero de datos

    [string]$anoActual = [string](get-date).Year
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - CHEQUEOS - INICIALES -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#   #
write-log -Text "----------- Nuevo LOG ------- " -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "--------- Iniciamos"      
    # ---------------------------------------------------------------------------------------------------------------------------------------------
    #   Verificación de variables.
    # ---------------------------------------------------------------------------------------------------------------------------------------------
    #
    # Validamos que exista el fichero de datos
    if ( Test-Path $fileIn ) {  # Existe el fichero de configuración
         write-log -Text "Existe el fichero:  $fileIn" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "File-Datos" 
    } else { # No Existe el fichero de configuración abortamos
         write-log -Text "Abortamos NO existe el fichero: $fileIn" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "File-Datos-Error" 
         exit 3
    }    
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - SCRIPT MAIN BODY - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
if ($anoDH -eq "" -or ($anoDH -lt "2010" -or $anoDH -gt $anoActual)) {
    [string]$anoDH = $anoActual      # Para test forzar el año, quitar -1 en producción
}
# coger año actual y sumarle 1 como límite del for
$anoInicial = 2021         # El inicio del for debe tener 2010, para extraer a partir de un año concreto o bien para pruebas 
[int16]$anoLim = (Get-date).Year    # Sí es hasta el año en curso no tocamos
for ($r = $anoInicial; $r -le $anoLim; $r++) {    
    [string]$anoDH = $r
    $nameFile = "sheet$anoDH" + ".html"
    for ($i = 13; $i -gt 0; $i--) {
        $mesDH = DAmESdE2 $i
        $primV = 0
        if ($mesDH -eq "13"){
            $textoBus = "/../$anoDH"
        } else {
            $textoBus = "/$mesDH/$anoDH"
        }
        $fileDep = Get-Content $fileIn | Select-String -Pattern $textoBus
        if ($fileDep.count -eq 0 -and $mesDH -eq "13") {
            exit 1             # No hay registros del año de búsqueda
        } elseif ($fileDep.count -eq 0 -and $mesDH -lt "13") {
            continue           # No hay registros para el mes dado de búsqueda
        } else {
            foreach ($datR in $fileDep) {
                [string]$dat = $datR
                $arrDat = $dat.split(";")
                $dosCamp = $arrDat[10] + " " + $arrDat[11] 
                # write-host $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5]  $arrDat[8]  $arrDat[9]  $arrDat[11]  $arrDat[12]  $arrDat[13]  
                write-host $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5]  $arrDat[8]  $arrDat[9]  $dosCamp  $arrDat[12]  $arrDat[13]  
                if ($primV -eq 0) {
                        $namefile = $nameFile.Substring(0,5) + $anoDH.Substring(2,2) + $mesDH + ".html" 
                        $dirSalida = $prefijo  + "HTML\salida\$anoDH"
                        verificarSalida $dirSalida
                        $rutaHTML = "$dirSalida\$nameFile"
                        f_Head $rutaHTML
                        $t = calTexto $i
                        $t = "$t $anoDH" 
                        f_IniBody $rutaHTML $t
                        f_CabeceraTab "FECHA" "DESCRIPCION" "IMPORTE" "SALDO" "CONCEPTO 2" "CONCEPTO 3" "CONCEPTO 4" "CONCEPTO 5"  "CONCEPTO 6" $rutaHTML
                        $primV++
                }
                f_detalle  $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5]  $arrDat[8]  $arrDat[9]  $dosCamp  $arrDat[12]  $arrDat[13] $rutaHTML
            }
            f_FinBody $rutaHTML
        }
    }
}
write-log -Text "*********** FIN LOG ******** " -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "*************** FIN **************"  
exit 0  # Salida si errores
# -------------------------------------------------------------------------------------------------------------------------------------------------