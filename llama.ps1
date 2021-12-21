#
Import-Module D:\data\PS\TOOLS\write-Log.psm1
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
function selDirectorio ($unidad) {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
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
#
# --------------------------------------------------------------------------------------------------------------------------------
#   SCRIPT MAIN BODY - START
# --------------------------------------------------------------------------------------------------------------------------------
#
    # Seleccionamos el directorio origen (local)
    $iData1 = selDirectorio "X:\SOFT"
    # $iData1 = selFile "X:\SOFT"
    if ($iData1 -eq "NoSel") {
        $texto="Error: No se ha seleccionado ningún directorio local CANCELAMOS EL PROCESO"
        write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
        exit 0
    }
    $fdOri1Tmp = $iData1.replace(":","$")
    $fdOri1 = "\\$maqLOCAL\$fdOri1Tmp"
    $data = obtieneDatos $xDoc $idata1
    if ($Data[0] -eq "0") {
        $texto="Error: datos incorrectos, CANCELAMOS EL PROCESO"
        write-log -Text $texto -LogFileDirectory $logDIR -LogFileName $LogNamePre -LogFase "=== F I N ==="
        exit 0
    }
    write-host "==========================================================================================================="
    write-host $data
    write-host "==========================================================================================================="