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
        $form.Size = New-Object System.Drawing.Size(500,300) 
        $form.Text = "Copia de fuentes a Test Local de CAD13"
    #   #
    # $OKButton_OnClick= { $Form.Close() }
        #
        # Add-Type -AssemblyName System.Windows.Forms
        # Add-Type -AssemblyName System.Drawing
        $x1=10; $x2=10
        $xbO=10; $ybO=435; $xbC=$xbO + 85; $xbh=$xbc + 85; $ybC=$ybO
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
        $lB1.Location = New-Object System.Drawing.Point($5,5) 
        $lB1.Size = New-Object System.Drawing.Size(300,20) 
        $lB1.Text = "Directorio origen (No modificable)"
        $form.Controls.Add($lB1)
        #> 
        # textBox1
        # Cuadro de texto no modificables para mostrar el directorio origen
        $tB1 = New-Object System.Windows.Forms.TextBox 
        $tB1.Location = New-Object System.Drawing.Point(5,25) # ($x2,60) 
        $tB1.Multiline="TRUE"
        $tb1.ReadOnly="TRUE"
        $tB1.Size = New-Object System.Drawing.Size(290,40) # (290,30) 
        $tB1.Text = "$dirOri"
        $form.Controls.Add($tB1) 
        #>
        # Etiqueta de textBox2
        $lB2 = New-Object System.Windows.Forms.Label
        $lB2.Location = New-Object System.Drawing.Point($x2,180) 
        $lB2.Size = New-Object System.Drawing.Size(300,30) 
        $lB2.Text = "Directorio en destino (Obligatorio)"
        $form.Controls.Add($lB2)
        #> 
        # textBox2
        # Cuadro de texto para pedir en directorio de destino en cada servidor
        $tB2 = New-Object System.Windows.Forms.TextBox 
        $tB2.Location = New-Object System.Drawing.Point($x2,240) # ($x2,60) 
        $tB2.Multiline="TRUE"
        $tB2.Size = New-Object System.Drawing.Size(290,40) # (290,30) 
        $tB2.Text = "$dirDest"
        # $tB2.Text = ""
        $form.Controls.Add($tB2)
        # Cuadro de opciones groupbox2
        $groupBox2 = New-Object System.Windows.Forms.GroupBox
        $groupBox2.Location = New-Object System.Drawing.Size($x2,10) # (80,5) 
        $groupBox2.size = New-Object System.Drawing.Size(385,110) 
        $groupBox2.text = "Acción: " 
        $Form.Controls.Add($groupBox2) 
        #
        $rB1 = New-Object System.Windows.Forms.RadioButton
        $rB1.Location = New-Object System.Drawing.Point(20,20) 
        $rB1.Size = New-Object System.Drawing.Size(85,20) 
        $rB1.Text = "1. HTML"
        $rB1.Checked = $true
        # $rb1.Add_Click({textoM}) 
        $groupBox2.Controls.Add($rB1)
        #
        $rB3 = New-Object System.Windows.Forms.RadioButton
        $rB3.Location = New-Object System.Drawing.Point(150,20) 
        $rB3.Size = New-Object System.Drawing.Size(80,20) 
        $rB3.Text = "2. SRC"
        $rB3.Checked = $false
        # $rb3.Add_Click({textoD}) 
        $groupBox2.Controls.Add($rB3)
        #
        $rB5 = New-Object System.Windows.Forms.RadioButton
        $rB5.Location = New-Object System.Drawing.Point(260,20) 
        $rB5.Size = New-Object System.Drawing.Size(70,20) 
        $rB5.Checked = $false
        $rB5.Text = "3. CSS"
        $groupBox2.Controls.Add($rB5)
        #
        $rB7 = New-Object System.Windows.Forms.RadioButton
        $rB7.Location = New-Object System.Drawing.Point(20,60) 
        $rB7.Size = New-Object System.Drawing.Size(130,20) 
        $rB7.Checked = $false
        $rB7.Text = "4. Salida"
        $groupBox2.Controls.Add($rB7)
        #
        $rB9 = New-Object System.Windows.Forms.RadioButton
        $rB9.Location = New-Object System.Drawing.Point(150,60) 
        $rB9.Size = New-Object System.Drawing.Size(110,20) 
        $rB9.Checked = $false
        $rB9.Text = "5. Todo"
        $groupBox2.Controls.Add($rB9)
        #
        $form.Topmost = $True
        $result = $form.ShowDialog() # Lo muestra modal.
        $Form.Add_Shown({$Form.Activate()})
        ####  La siguiente me provocaba el pulsar 2 veces el boton de OK.
        ####  [void] $Form.ShowDialog()
        #
        # $res1=$listbox.SelectedItems
        $dimen = 3
        $res = New-Object string[] $dimen
        $res[0] = $tB1.Text  # Directorio origen  
        $res[1] = $tB2.Text  # Directorio destino
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $res[0] = $tB1.Text  # Directorio origen  
            $res[1] = $tB2.Text  # Directorio destino
            if ($rB1.checked) {
                $res[2] = "1"
            } else  {    
                if ($rB3.checked) {
                    $res[2] = "2"
                } elseif ($rB5.checked) { 
                    $res[2] = "3"
                } elseif ($rB7.checked) {
                    $res[2] = "4" 
                } else {
                    $res[2] = "5"
                }
            }
        } else {
            $res[0] = "0"  
            $res[1] = "0"  
        }
        return $res
    }
    #
    Exit 0