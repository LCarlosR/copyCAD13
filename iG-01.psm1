<#  01
##################################################################################
#         PowerShell Modulo: IG-01.psm1                                          #
##################################################################################
# Inclusión en otros PS                                                          #
# Import-Module Producción D:\data\PS\sAutoDistribucion\SOUtil\LIB\IG-01.psm1    #
# Import-Module Test D:\miData\Hostalia\bankiaAD\scripts\IG-01.psm1              #
##################################################################################
# Llamada:                                                                       #
# flogin                                                                         #
# if ($login -eq $null -or $login -eq "`n`n") {                                  #
# write-host "Faltan parametros ... salimos"                                     #
# }                                                                              #    
# $t=ftextBox                                                                    #
# fcalendario                                                                    #
# Argumentos: 0 = tipo (Error, Warning, Info, None),                             #
# 1 = mensaje, 2 = titulo, 3 = tiempo en msg                                     #
# fnotificacion "Error" "Opcion de la leche" "El titulo" 1000                    #
# Argumentos: 0 = mensaje, 1 = titulo, 2 = tipo boton                            #
# fmessageBox "Tu mensaje" "Titulo" "AbortRetryIgnore"                           #
# Argumentos: 0 = titulo, 1 = texto                                              #
# fRichTextBox "Mi Título" "Si te ví no me acuerdo"                              #
# $s=sDialogo                                                                    #
##################################################################################
# Referencias:                                                                   #
# http://technet.microsoft.com/en-us/library/ff730952.aspx                       #
# http://technet.microsoft.com/en-us/library/ff730941.aspx                       #
##################################################################################
#>
#$ErrorActionPreference = "silentlycontinue"
$ErrorActionPreference = "Inquire"
Clear-Host
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#$camino =  Split-Path -Parent $MyInvocation.MyCommand.Path
#
function flogin {
    $servidor = ""
    $texto = ""
    $modo = ""

    $objForm = New-Object System.Windows.Forms.Form 
    $objForm.Text = "For1"
    $objForm.Size = New-Object System.Drawing.Size(300,250) 
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
        {$x=$objTextBox.Text;$y=$objTextBox2.Text;$z=$objTextBox3.Text;$objForm.Close()}})
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
        {$objForm.Close()}})

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75,190)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({$x=$objTextBox.Text;$y=$objTextBox2.Text;$z=$objTextBox3.Text;$objForm.Close()})
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(250,190)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancelar"
    $CancelButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($CancelButton)

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,20) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = "Servidor "
    $objLabel2 = New-Object System.Windows.Forms.Label
    $objLabel2.Location = New-Object System.Drawing.Size(10,70) 
    $objLabel2.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel2.Text = "Comentario "
    $objLabel3 = New-Object System.Windows.Forms.Label
    $objLabel3.Location = New-Object System.Drawing.Size(10,120) 
    $objLabel3.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel3.Text = "Acción "
    $objForm.Controls.Add($objLabel) 
    $objForm.Controls.Add($objLabel2) 
    $objForm.Controls.Add($objLabel3) 

    $objTextBox = New-Object System.Windows.Forms.TextBox 
    $objTextBox.Location = New-Object System.Drawing.Size(10,40) 
    $objTextBox.Size = New-Object System.Drawing.Size(260,20) 

    $objTextBox2 = New-Object System.Windows.Forms.TextBox 
    $objTextBox2.Location = New-Object System.Drawing.Size(10,90) 
    $objTextBox2.Size = New-Object System.Drawing.Size(260,20) 
#   $objTextBox2.PasswordChar = '*'

    $objTextBox3 = New-Object System.Windows.Forms.TextBox 
    $objTextBox3.Location = New-Object System.Drawing.Size(10,140) 
    $objTextBox3.Size = New-Object System.Drawing.Size(260,20) 

    ########## PERSONALIZAR ######################
    $objTextBox.Text = "XSAP*"
    $objTextBox2.Text = "Sistema en intervencion. Por favor, no levantad incidencias."
    $objTextBox3.Text = "Mon Des"

    ########## ############ ######################
    $objForm.Controls.Add($objTextBox) 
    $objForm.Controls.Add($objTextBox2)
    $objForm.Controls.Add($objTextBox3)

    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})
    [void] $objForm.ShowDialog()
    #return 
    $servidor = $objTextBox.Text; $texto = $objTextBox2.Text; $modo = $objTextBox3.Text
    return $servidor + "`n" + $texto + "`n" + $modo
}
#
function ftextbox {
    
    # ref http://technet.microsoft.com/en-us/library/ff730941.aspx
    # argumentos: 0 = titulo, 1 = etiqueta textbox, 2 = Es password: true | false
    $objForm = New-Object System.Windows.Forms.Form 
    $objForm.Text = $Args[0]
    $objForm.Size = New-Object System.Drawing.Size(300,200) 
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
        {$x=$objTextBox.Text;$objForm.Close()}})
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
        {$objForm.Close()}})

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancelar"
    $CancelButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($CancelButton)

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,20) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = $Args[1]
    $objForm.Controls.Add($objLabel) 

    $objTextBox = New-Object System.Windows.Forms.TextBox 
    $objTextBox.Location = New-Object System.Drawing.Size(10,40) 
    $objTextBox.Size = New-Object System.Drawing.Size(260,20) 
    if ($Args[2] -eq "true") { $objTextBox.PasswordChar = '*'}
    $objForm.Controls.Add($objTextBox) 

    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})
    [void] $objForm.ShowDialog()
    return $objTextBox.Text
     
}
#
function fcalendario {
    $objForm = New-Object Windows.Forms.Form 
    $objForm.Text = "Seleccione fecha y pulse OK/intro" 
    $objForm.Size = New-Object Drawing.Size @(340,200) 
    $objForm.StartPosition = "CenterScreen"
    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({
        if ($_.KeyCode -eq "Enter") 
            {
                $objForm.Close();
            }
        })

    $objForm.Add_KeyDown({
        if ($_.KeyCode -eq "Escape") 
            {
                $objForm.Close()
            }
        })
        
    $objCalendar = New-Object System.Windows.Forms.MonthCalendar 
    $objCalendar.ShowTodayCircle = $False
    $objCalendar.MaxSelectionCount = 1   
    $objForm.Controls.Add($objCalendar) 

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(240,70)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({$objForm.Close()})    
    $objForm.Controls.Add($OKButton)
    
    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})  
    [void] $objForm.ShowDialog()
    
    return (Get-Date ($objCalendar.SelectionEnd.Date) -Format dd/MM/yyyy).ToString()
}
#
function fnotificacion {
    # ref http://technet.microsoft.com/en-us/library/ff730952.aspx
    #Argumentos: 0 = tipo (Error, Warning, Info, None), 1 = mensaje, 2 = titulo, 3 = tiempo en msg
    $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
    #$camino =  Split-Path -Parent $MyInvocation.MyCommand.Path
    $objNotifyIcon.Icon = [System.Drawing.SystemIcons]::Information
    $objNotifyIcon.BalloonTipIcon = $Args[0] # Error, Warning, Info, None
    $objNotifyIcon.BalloonTipText = $Args[1] # mensaje" 
    $objNotifyIcon.BalloonTipTitle = $Args[2] # titulo
    $objNotifyIcon.Visible = $True 
    $objNotifyIcon.ShowBalloonTip([int] $Args[3]) # delay
    [Threading.Thread]::Sleep([int] $Args[3])
    $objNotifyIcon.Dispose()
}
#
function fmessageBox {
    #Argumentos: 0 = mensaje, 1 = titulo, 2 = tipo boton (OK, OKCancel, AbortRetryIgnore, YesNoCancel, YesNo, RetryCancel)
    [System.Windows.Forms.MessageBox]::Show($args[0],$args[1],$args[2])
}
#
function fRichTextBox {
    #argumentos: 0 = titulo, 1 = texto
    $objForm = New-Object System.Windows.Forms.Form 
    $objForm.Text = $Args[0]
    $objForm.Size = New-Object System.Drawing.Size(300,300) 
    $objForm.StartPosition = "CenterScreen"

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(55,240)
    $OKButton.Size = New-Object System.Drawing.Size(175,23)
    $OKButton.Text = "Cerrar y copiar al portapapeles"
    $OKButton.Add_Click({
        $copiar = $richTextBox1.Text
        [Windows.Forms.Clipboard]::SetText($copiar)
        $objForm.Close()})
    $objForm.Controls.Add($OKButton)

    $richTextBox1 = New-Object System.Windows.Forms.RichTextBox
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 10
    $System_Drawing_Point.Y = 20
    $richTextBox1.Location = $System_Drawing_Point
    $richTextBox1.Name = "richTextBox1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 200
    $System_Drawing_Size.Width = 255
    $richTextBox1.Size = $System_Drawing_Size
    $richTextBox1.Text = $Args[1]
    $objForm.Controls.Add($richTextBox1) 

    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})
    [void] $objForm.ShowDialog()
    $copiar = $richTextBox1.Text

}