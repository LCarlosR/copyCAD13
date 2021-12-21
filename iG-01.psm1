#
# Import-Module C:\sAutoDistribucion\LIB\write-Log.psm1
#
# ----------------------------------------------------------------------------------------------------------------------
# - CAPTURA DE PANTALLAS DE SELECCIÓN DE DATOS -
# ----------------------------------------------------------------------------------------------------------------------
#
#  Funcion obtiene datos 
#  Captura entorno (Des, Int, Pro, All)
#  Devuelve el array $res
#  $res[0] -> [ 0 | 1 ] [ 0-> Cancelamos | 1-> hay selección ]
#  $res[1] -> Directorio del destino remoro
#  $res[2] -> [Combinar|Sustituir|Borrar]
#  $res[3] -> DSAPCCU1
#  $res[4] -> DSAPDM02
#  $res[...] -> .... tantos registros como máquinas selecionadas
#
function obtieneDatos ($dirOri, $dirDest) {
    #   #
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
        $Form = New-Object System.Windows.Forms.Form    
        $form.StartPosition = "Manual"
        $form.Location = New-Object System.Drawing.Point(55,5)
        $form.Size = New-Object System.Drawing.Size(700,720) 
        $form.Text = "LCR Copia un directorio local maquinas remotas"
    #   #
    # $OKButton_OnClick= { $Form.Close() }
        #
        # Add-Type -AssemblyName System.Windows.Forms
        # Add-Type -AssemblyName System.Drawing
        $x1=10; $x2=290
        $xbO=400; $ybO=635; $xbC=$xbO + 85; $xbh=$xbc + 85; $ybC=$ybO
        # X1 $form = New-Object System.Windows.Forms.Form 
        # $form.StartPosition = "CenterScreen"
        #
        # Boton 1 -> OK
        $OKButton = New-Object System.Windows.Forms.Button
        $OKButton.Location = New-Object System.Drawing.Point($xbO,$ybO)
        $OKButton.Size = New-Object System.Drawing.Size(75,23)
        $OKButton.Text = "OK"
        $OKButton.BackColor = "Green" 
        $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $OKButton.add_Click($OKButton_OnClick)
        $form.AcceptButton = $OKButton
        $form.Controls.Add($OKButton)
        #
        # Boton 2 -> Cancel
        $CancelButton = New-Object System.Windows.Forms.Button
        $CancelButton.Location = New-Object System.Drawing.Point($xbC,$ybC)
        $CancelButton.Size = New-Object System.Drawing.Size(75,23)
        $CancelButton.Text = "Cancel"
        $CancelButton.BackColor = "Red" 
        $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.CancelButton = $CancelButton
        $form.Controls.Add($CancelButton)
        #
        <#    
        # Boton 3 -> Help
        $Title="123"; $boxbody="456"; $boxBoton="None"; $boxMIconV="Cancel"
        #
        $helpButton = New-Object System.Windows.Forms.Button
        $helpButton.Location = New-Object System.Drawing.Point($xbh,$ybC)
        $helpButton.Size = New-Object System.Drawing.Size(75,23)
        $helpButton.Text = "Help"
        $helpButton.BackColor = "Red" 
        $helpButton.DialogResult = [System.Windows.Forms.DialogResult]::None
        $helpButton.Add_Click({mensajePopup $Title $boxbody $boxBoton $boxMIcon}) 
        $form.helpButton = $helpButton
        $form.Controls.Add($helpButton)
        #>
        #
        # Etiqueta de textBox1
        $lB1 = New-Object System.Windows.Forms.Label
        # $lB1.Location = New-Object System.Drawing.Point($x2,225) 
        $lB1.Location = New-Object System.Drawing.Point($x2,425) 
        $lB1.Size = New-Object System.Drawing.Size(300,20) 
        $lB1.Text = "Directorio origen (Obligatorio Opciones 1,2,3)"
        $form.Controls.Add($lB1)
        #> 
        # textBox1
        # Cuadro de texto no modificables para mostrar el directorio origen
        $tB1 = New-Object System.Windows.Forms.TextBox 
        $tB1.Location = New-Object System.Drawing.Point($x2,450) # ($x2,60) 
        $tB1.Multiline="TRUE"
        $tb1.ReadOnly="TRUE"
        $tB1.Size = New-Object System.Drawing.Size(290,40) # (290,30) 
        $tB1.Text = "$dirOri"
        $form.Controls.Add($tB1) 
        #>
        # Etiqueta de textBox2
        $lB2 = New-Object System.Windows.Forms.Label
        $lB2.Location = New-Object System.Drawing.Point($x2,510) 
        $lB2.Size = New-Object System.Drawing.Size(300,30) 
        $lB2.Text = "Directorio en destino (debe comenzar con <Unidad:\?> (Obligatorio Opciones 1,2,3,4))"
        $form.Controls.Add($lB2)
        #> 
        # textBox2
        # Cuadro de texto para pedir en directorio de destino en cada servidor
        $tB2 = New-Object System.Windows.Forms.TextBox 
        $tB2.Location = New-Object System.Drawing.Point($x2,550) # ($x2,60) 
        $tB2.Multiline="TRUE"
        $tB2.Size = New-Object System.Drawing.Size(290,40) # (290,30) 
        $tB2.Text = "$dirDest"
        # $tB2.Text = ""
        $form.Controls.Add($tB2)
        #>
        #
        $form.Topmost = $True
        $result = $form.ShowDialog() # Lo muestra modal.
        $Form.Add_Shown({$Form.Activate()})
        ####  La siguiente me provocaba el pulsar 2 veces el boton de OK.
        ####  [void] $Form.ShowDialog()
        #
        # $res1=$listbox.SelectedItems
        $res = New-Object string[] $dimen
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $res[0] = $tB1.Text  # Directorio origen  
            $res[1] = $tB2.Text  # Directorio destino
        } else {
            $res[0] = "0"  
            $res[1] = "0"  
        }
        return $res
    }
    #
    function mensajePopup ($Title, $boxbody, $boxBoton, $boxMIcon ) {
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::$boxBoton
        $MessageboxTitle = $Title 
        $Messageboxbody = $boxbody
        $MessageIcon = [System.Windows.MessageBoxImage]::$boxMIcon
        # $Result = [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$messageicon)
        $Result = [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle)
        # return $result
    }
    #
    function textoM () {
        $tB1.Text = "Sistema en operacion normal y monitorizado. "
    }
    #
    function textoD () {
        $tB1.Text = "Sistema en intervencion y desmonitorizado. Por favor, no levantad incidencias. "
    }
    #
    Exit 0