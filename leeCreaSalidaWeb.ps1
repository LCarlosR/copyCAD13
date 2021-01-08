#**************************************************************************************************************************************************
#*      Fichero:  C:\miData\Hostalia\bankiaAD\scripts\leeCreaSalidaWeb.ps1                              
#*        Autor:  Carlos Ruiz                                                           
#*      Version:  1.0                                                                   
#* Fecha inicio:  18/09/2020                                                                                                                        
#*     Objetivo:  Lee un ficheo de BK en CSV y genera un HTML con los datos de un mes en concreto
#* Parámetros IN: nombre del fichero de entrada default "datosMBK21.csv"  
#*
#* Fecha modif.:  06/01/2021                                                           
#*     Objetivo:  Generar todos los ficheros "mes a mes" y el anual con el nombre "sheetYY13.htm"
#*Parámetros IN:  nombre del fichero de datos (default):  "datosMBK21.csv", pondremos el correspondiente al año, no es necesario que tenga cabecera
#*       Salida:  D:\LES008066\miData\Hostalia\bankiaAD\salidaYYYY
#*                         
#**************************************************************************************************************************************************
#
#**************************************************************************************************************************************************
# -   PARÁMETROS IN    -
#**************************************************************************************************************************************************
    Param ( 
        [string] $nameFileIn   = "datosMBK21.csv"    
    )
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# -   IMPORT MODULES   -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
Import-Module D:\LES008066\data\PS\TOOLS\write-Log.psm1
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - FUNCTIONS - STARTS -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
Function f_Head ($nameF) { 
    #'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' | Out-File "$rutaHTML" -Encoding   UTF8
     "<html xmlns:v=`"urn:schemas-microsoft-com:vml`""                                                                       | Out-File "$rutaHTML" -Encoding            UTF8
       "xmlns:o=`"urn:schemas-microsoft-com:office:office`""                                                                 | Out-File "$rutaHTML" -Append  -Encoding   UTF8
       "xmlns:x=`"urn:schemas-microsoft-com:office:excel`""                                                                  | Out-File "$rutaHTML" -Append  -Encoding   UTF8
       "xmlns=`"http://www.w3.org/TR/REC-html40`">"                                                                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
        "<head>"                                                                                                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            "<meta http-equiv=Content-Type content=`"text/html; charset=windows-1252`">"                                     | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            "<meta name=ProgId content=Excel.Sheet>"                                                                         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            "<meta name=Generator content=`"Microsoft Excel 15`">"                                                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            "<link id=Main-File rel=Main-File href=`"$nameF`">"                                                              | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            "<link rel=Stylesheet href=stylesheet.css>"                                                                      | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            "<style>"                                                                                                        | Out-File "$rutaHTML" -Append  -Encoding   UTF8
                '<!--table'                                                                                                  | Out-File "$rutaHTML" -Append  -Encoding   UTF8
   	            '    {mso-displayed-decimal-separator:"\,";'                                                                 | Out-File "$rutaHTML" -Append  -Encoding   UTF8
	            '    mso-displayed-thousand-separator:"\.";}'                                                                | Out-File "$rutaHTML" -Append  -Encoding   UTF8
                '@page'                                                                                                      | Out-File "$rutaHTML" -Append  -Encoding   UTF8
	            '    {margin:1.0in .75in 1.0in .75in;'                                                                       | Out-File "$rutaHTML" -Append  -Encoding   UTF8
	            '    mso-header-margin:.5in;'                                                                                | Out-File "$rutaHTML" -Append  -Encoding   UTF8
	            '    mso-footer-margin:.5in;}'                                                                               | Out-File "$rutaHTML" -Append  -Encoding   UTF8
                '-->'                                                                                                        | Out-File "$rutaHTML" -Append  -Encoding   UTF8
            '</style>'                                                                                                       | Out-File "$rutaHTML" -Append  -Encoding   UTF8
        '</head>'                                                                                                            | Out-File "$rutaHTML" -Append  -Encoding   UTF8
}
#
Function f_IniBody ([string]$fecha) { 
    "<body link=`"#0563C1`" vlink=`"#954F72`">"                                              | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "<table border=0 cellpadding=0 cellspacing=0 width=1080 style='border-collapse:"         | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "collapse;table-layout:fixed;width:810pt'>"                                              | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "<col width=120 span=9 style='mso-width-source:userset;mso-width-alt:4388; width:90pt'>" | Out-File "$rutaHTML" -Append  -Encoding   UTF8
}
#
# FECHA;FEC. VALOR;DESCRIPCION;IMPORTE;DIV.;SALDO;DIV.;CATEGORÍA;CONCEPTO 2;CONCEPTO 3;CONCEPTO 4;CONCEPTO 5;CONCEPTO 6;CONCEPTO 7
# FECHA            DESCRIPCION IMPORTE      SALDO                CONCEPTO 2 CONCEPTO 3 CONCEPTO 4 CONCEPTO 5 CONCEPTO 6 CONCEPTO 7
# $dt0,            $dt2,       $dt3,        $dt5,                $dt8,      $dt9,      $dt10,     $dt11,     $dt12,     $dt13,     $dt14
# f_detalle $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5] $arrDat[8] $arrDat[9] $arrDat[10] $arrDat[11] $arrDat[12] $arrDat[13] $arrDat[14]  
Function f_CabeceraTab ($dt0, $dt2, $dt3, $dt5, $dt8, $dt9, $dt10, $dt11, $dt12, $dt13, $dt14) {
    "<tr height=21 style=`"height:15.75pt`">"                                              | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td height=21 class=xl65 width=120 style='height:15.75pt;width:90pt'>$dt0</td>"    | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt2</td>"                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt3</td>"                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt5</td>"                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt8</td>"                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt9</td>"                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt10</td>"                            | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt11</td>"                            | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "   <td class=xl66 width=120 style='width:90pt'>$dt12</td>"                            | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "</tr>"                                                                                | Out-File "$rutaHTML" -Append  -Encoding   UTF8
}
#
Function f_Detalle ($dt0, $dt2, $dt3, $dt5, $dt8, $dt9, $dt10, $dt11, $dt12, $13, $14) {
    "<tr height=46 style='height:34.5pt'>"                                              | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td height=46 class=xl67 width=120 style='height:34.5pt;width:90pt'>$dt0</td>"   | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt2</td>"                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt3</td>"                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt5</td>"                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt8</td>"                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt9</td>"                           | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt11</td>"                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt12</td>"                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "  <td class=xl68 width=120 style='width:90pt'>$dt13</td>"                          | Out-File "$rutaHTML" -Append  -Encoding   UTF8
    "</tr>"                                                                             | Out-File "$rutaHTML" -Append  -Encoding   UTF8
}
#
Function f_FinBody () { 
    "<![if supportMisalignedColumns]>"               | Out-File $rutaHTML -Append   -Encoding   UTF8
    "   <tr height=0 style='display:none'>"          | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "       <td width=120 style='width:90pt'></td>"  | Out-File $rutaHTML -Append   -Encoding   UTF8
    "   </tr>"                                       | Out-File $rutaHTML -Append   -Encoding   UTF8
    "<![endif]>"                                     | Out-File $rutaHTML -Append   -Encoding   UTF8
    "</table>"                                       | Out-File $rutaHTML -Append   -Encoding   UTF8
    "</body>"                                        | Out-File $rutaHTML -Append   -Encoding   UTF8
    "</html>"                                        | Out-File $rutaHTML -Append   -Encoding   UTF8
}
#
#
Function daMesDe2 ([string]$md) { 
    if ($md.length -lt 2) {
         $md = "0" + $md
    }
    return $md
}
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - VARIABLES - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
    $prefijo = "D:\LES008066\miData\Hostalia\testPS-HTML\"
    # $fe = "MBK_" + (get-date -format "yyyymmdd").ToString() + "-" + (get-date -format "hhmm").ToString() + ".log"
    $logDIR   = $prefijo + "LOG\"
    $LogNamePre = "LOG-MBK-"
    $fileIn = $prefijo + "filesMov\$nameFileIn"            # Ruta dónde está el fichero de datos
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - CHEQUEOS - INICIALES -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#   #
    # ---------------------------------------------------------------------------------------------------------------------------------------------
    #   Verificación de variables.
    # ---------------------------------------------------------------------------------------------------------------------------------------------
    #
    # Validamos que exista el fichero de datos
    if ( Test-Path $fileIn ) {  # Existe el fichero de configuración
         write-log -Text "Existe el fichero:  $fileIn" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File" 
    } else { # No Existe el fichero de configuración abortamos
         write-log -Text "Abortamos NO existe el fichero: $fileIn" -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "Check-File-Error" 
         exit 3
    }    
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - SCRIPT MAIN BODY - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
$y1 = ([string](Get-Date).year).substring(2, 2) 
$nameFile = $nameFile.replace("YY",$y1)
[string]$anoDH = (Get-date).Year # - 1     # Quitar -1 en producción

for ($i = 13; $i -gt 0; $i--) {
    $mesDH = DAmESdE2 $i
    $primV = 0
    if ($mesDH -eq "13"){
        $textoBus = "/../$anoDH"
    } else {
        $textoBus = "/$mesDH/$anoDH"
    }
    $fileDep = gc $fileIn | Select-String -Pattern $textoBus
    if ($fileDep.count -eq 0 -and $mesDH -eq "13") {
        exit 1             # No hay registros del año de búsqueda
    } elseif ($fileDep.count -eq 0 -and $mesDH -lt "13") {
        continue           # No hay registros para el mes dado de búsqueda
    } else {
        foreach ($datR in $fileDep) {
            [string]$dat = $datR
            $arrDat = $dat.split(";")
            write-host $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5]  $arrDat[8]  $arrDat[9]  $arrDat[10]  $arrDat[11]  $arrDat[12]  $arrDat[13]  $arrDat[14] 
            if ($primV -eq 0) {
                    $namefile = $nameFile.Substring(0,5) + $anoDH.Substring(2,2) + $mesDH + ".htm" 
                    $rutaHTML = $prefijo + "salida$anoDH\$nameFile"
                    f_Head $nameFile
                    f_IniBody 
                    f_CabeceraTab "FECHA" "FEC. VALOR" "DESCRIPCION" "IMPORTE" "DIV." "CATEGORIA" "CONCEPTO 2" "CONCEPTO 3" "CONCEPTO 4" "CONCEPTO 5"  "CONCEPTO 6" "CONCEPTO 7"  
                    $primV++
            }
            f_detalle  $arrDat[0] $arrDat[2] $arrDat[3] $arrDat[5]  $arrDat[8]  $arrDat[9]  $arrDat[10]  $arrDat[11]  $arrDat[12]  $arrDat[13]  $arrDat[14]
        }
        f_FinBody
    }
}
exit 0  # Salida si errores
# -------------------------------------------------------------------------------------------------------------------------------------------------