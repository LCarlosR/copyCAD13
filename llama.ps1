#
Import-Module D:\data\PS\TOOLS\write-Log.psm1
Import-Module D:\miData\Hostalia\bankiaAD\scripts\IG-01.psm1
#
# Selecciona un fichero
Function Get-FileName($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory

    $OpenFileDialog.ValidateNames = $false
    $OpenFileDialog.CheckFileExists = $false
    $OpenFileDialog.CheckPathExists = $true
    $OpenFileDialog.FileName = "Folder Selection."
    
    # $OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    # $OpenFileDialog.filter = "LOG (*.log)| *.log"
    $OpenFileDialog.ShowDialog() | Out-Null
    # $OpenFileDialog.filename
}  ## End Function Get-FileName
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
#
function selFile ($unidad) {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    # $Browse = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
    $Browse = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
    $browse.SelectedPath = $unidad
    $browse.ShowNewFolderButton = $false
    $browse.Description = "Elija un directorio"
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
#
# -------------------------------------------------------------------------------------------------------------------------------------------------
# - VARIABLES - START -
# -------------------------------------------------------------------------------------------------------------------------------------------------
#
    $LogNamePre = "LOG-COPIA-"
    $prefijo    = "D:\miData\Hostalia\bankiaAD"
    $logDIR     = $prefijo + "\LOG\"
    #   Lee el fichero de maquinas:
    $maquinaXML="D:\miData\Hostalia\bankiaAD\scripts\maquinasXSO.xml"
    $xdoc=New-Object System.Xml.XmlDataDocument
    $fileXML=$maquinaXML
    [xml]$xdoc=get-content $fileXML
#
# --------------------------------------------------------------------------------------------------------------------------------
#   SCRIPT MAIN BODY - START
# --------------------------------------------------------------------------------------------------------------------------------
#
    # Seleccionamos el directorio origen (local)
    # $iData1 = selDirectorio "D:\miData\Hostalia\bankiaAD\HTML" "Directorio por defecto: D:\miData\Hostalia\bankiaAD\HTML"
    $iData1 = "D:\miData\Hostalia\bankiaAD\HTML" 
    <#
    if ($iData1 -eq "NoSel") {
        $texto="Error: No se ha seleccionado ningún directorio local CANCELAMOS EL PROCESO"
        write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
        exit 0
    }
    #>
    $iData2 = selDirectorio "H:\xampp\htdocs\web\bankiaAD\HTML" "Directorio por defecto: H:\xampp\htdocs\web\bankiaAD\HTML"
    if ($iData2 -eq "NoSel") {
        $texto="Error: No se ha seleccionado ningún directorio local CANCELAMOS EL PROCESO"
        write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
        exit 0
    }
    $data = obtieneDatos $iData1 $idata2
    if ($Data[0] -eq "0") {
        $texto="Proceso cancelado por el usuario"
        write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
        exit 0
    }
    write-host "==========================================================================================================="
    foreach ($a in $data) {
        write-host $a
    }
    write-host "==========================================================================================================="