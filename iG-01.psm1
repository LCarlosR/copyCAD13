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
function obtieneDatos ($maquinas, $dirOri) {
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
        $tB2.Text = "$dirOri"
        # $tB2.Text = ""
        $form.Controls.Add($tB2)
        #>
        # Cuadro de opciones groupbox2
        $groupBox2 = New-Object System.Windows.Forms.GroupBox
        $groupBox2.Location = New-Object System.Drawing.Size($x2,150) # (80,5) 
        $groupBox2.size = New-Object System.Drawing.Size(385,130) 
        $groupBox2.text = "Acción: " 
        $Form.Controls.Add($groupBox2) 
        #   #
            $rB1 = New-Object System.Windows.Forms.RadioButton
            $rB1.Location = New-Object System.Drawing.Point(20,20) 
            $rB1.Size = New-Object System.Drawing.Size(85,20) 
            $rB1.Text = "1.Combinar"
            $rB1.Checked = $true
            # $rb1.Add_Click({textoM}) 
            $groupBox2.Controls.Add($rB1)
            #
            $rB3 = New-Object System.Windows.Forms.RadioButton
            $rB3.Location = New-Object System.Drawing.Point(150,20) 
            $rB3.Size = New-Object System.Drawing.Size(80,20) 
            $rB3.Text = "2.Sustituir"
            $rB3.Checked = $false
            # $rb3.Add_Click({textoD}) 
            $groupBox2.Controls.Add($rB3)
            #
            $rB5 = New-Object System.Windows.Forms.RadioButton
            $rB5.Location = New-Object System.Drawing.Point(260,20) 
            $rB5.Size = New-Object System.Drawing.Size(70,20) 
            $rB5.Checked = $false
            $rB5.Text = "3.Borrar"
            $groupBox2.Controls.Add($rB5)
            #
            $rB7 = New-Object System.Windows.Forms.RadioButton
            $rB7.Location = New-Object System.Drawing.Point(20,60) 
            $rB7.Size = New-Object System.Drawing.Size(130,20) 
            $rB7.Checked = $false
            $rB7.Text = "4.Duplica Directorio"
            $groupBox2.Controls.Add($rB7)
            #
            $rB9 = New-Object System.Windows.Forms.RadioButton
            $rB9.Location = New-Object System.Drawing.Point(150,60) 
            $rB9.Size = New-Object System.Drawing.Size(110,20) 
            $rB9.Checked = $false
            $rB9.Text = "5.Copia Kernel"
            $groupBox2.Controls.Add($rB9)
            #
            $rB11 = New-Object System.Windows.Forms.RadioButton
            $rB11.Location = New-Object System.Drawing.Point(260,60) 
            $rB11.Size = New-Object System.Drawing.Size(110,20) 
            $rB11.Checked = $false
            $rB11.Text = "6.Duplica Kernel"
            $groupBox2.Controls.Add($rB11)
            #
            $rB13 = New-Object System.Windows.Forms.RadioButton
            $rB13.Location = New-Object System.Drawing.Point(20,100) 
            $rB13.Size = New-Object System.Drawing.Size(110,20) 
            $rB13.Checked = $false
            $rB13.Text = "7.Lista Directorio"
            $groupBox2.Controls.Add($rB13)
            #
            $rB15 = New-Object System.Windows.Forms.RadioButton
            $rB15.Location = New-Object System.Drawing.Point(150,100) 
            $rB15.Size = New-Object System.Drawing.Size(130,20) 
            $rB15.Checked = $false
            $rB15.Text = "8.Parada Forzada"
            $groupBox2.Controls.Add($rB15)
        #>  
        ############################################## Start group boxes & components
        #
        $gBDIP = New-Object System.Windows.Forms.GroupBox
        $gBDIP.Location = New-Object System.Drawing.Size($x2,20) 
        $gBDIP.size = New-Object System.Drawing.Size(145,100) 
        $gBDIP.text = "   Entorno   " 
        $Form.Controls.Add($gBDIP) 
        #   #
            $rbDes = New-Object System.Windows.Forms.RadioButton
            $rbDes.Location = New-Object System.Drawing.Size(10,20)
            $rbDes.Size = New-Object System.Drawing.Size(100,20)
            $rbDes.Checked = $false
            $rbDes.Text = "Desarrollo"
            $gBDIP.Controls.Add($rbDes)
            #
            $rbInt = New-Object System.Windows.Forms.RadioButton
            $rbInt.Location = New-Object System.Drawing.Size(10,40)
            $rbInt.Size = New-Object System.Drawing.Size(100,20)
            # $rbInt.Checked = $false
            $rbInt.Text = "Integración"
            $gBDIP.Controls.Add($rbInt)
            #
            $rbPro = New-Object System.Windows.Forms.RadioButton
            $rbPro.Location = New-Object System.Drawing.Size(10,60)
            $rbPro.Size = New-Object System.Drawing.Size(100,20)
            # rbPro.Checked = $false
            $rbPro.Text = "Producción"
            $gBDIP.Controls.Add($rbPro)        
            #
            $rbAll = New-Object System.Windows.Forms.RadioButton
            $rbAll.Location = New-Object System.Drawing.Size(10,80)
            $rbAll.Size = New-Object System.Drawing.Size(100,20)
            $rbAll.Text = "*** TODOS ***"
            $gBDIP.Controls.Add($rbAll)
        #   #
        #
        ############################################## end radio buttons
        # Botón para ver los servidores 
        $exeButton = New-Object System.Windows.Forms.Button 
        $exeButton.Location = New-Object System.Drawing.Size(440,60) # (440,140) 
        $exeButton.Size = New-Object System.Drawing.Size(150,25) # (75,20) 
        $exeButton.Text = "Pulsar para ver Servidores" 
        $exeButton.BackColor = "Yellow" 
        $exeButton.Add_Click({cargaDatosMaquinas $maquinas}) 
        #$exeButton.Click({cargaDatosMaquinas $maquinas}) 
        $Form.Controls.Add($exeButton) 
        #<# quitamos la visualización de servidores 
        # New-1
        # Cuadro para mostrar los servidores
        $dataGridView1 = New-Object System.Windows.Forms.DataGridView
        $dataGridView1.Location=New-Object System.Drawing.Point(10,10)
        $dataGridView1.Size=New-Object System.Drawing.Size(260,650)
        $dataGridView1.ColumnCount = 1
        $dataGridView1.ColumnHeadersVisible = $true
        $dataGridView1.Columns[0].Name = "Servidores"
        $dataGridView1.Name = "SERVIDORES"
        $form.Controls.Add($dataGridView1) 
        # New-1
        #>
        #
        $form.Topmost = $True
        $result = $form.ShowDialog() # Lo muestra modal.
        $Form.Add_Shown({$Form.Activate()})
        ####  La siguiente me provocaba el pulsar 2 veces el boton de OK.
        ####  [void] $Form.ShowDialog()
        #
        # $res1=$listbox.SelectedItems
        $res1=$dataGridView1.SelectedCells
        if ($res1.count -gt 0) {
            $dimen = $res1.count + 4
            $res = New-Object string[] $dimen
            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                $res[0] = "1"  
                $res[1] = $tB2.Text  # Directorio destino remoto
                if ($rB1.checked) {
                    $res[0] = "1"
                    $res[2] = "Combinar" 
                } else  {    
                    if ($rB3.checked) {
                        $res[0] = "2"
                        $res[2] = "Sustituir" 
                    } elseif ($rB5.checked) { 
                        $res[0] = "3"
                        $res[2] = "Borrar"
                    } elseif ($rB7.checked) {
                        $res[0] = "4" 
                        $res[2] = "Copiar"
                    } elseif ($rB9.checked) {
                        $res[0] = "5" 
                        $res[2] = "CopKernel"
                    } elseif ($rB11.checked) {
                        $res[0] = "6" 
                        $res[2] = "DupKernel"
                    } elseif ($rB13.checked) {
                        $res[0] = "7"
                        $res[2] = "VerDir"
                    } else {
                        $res[0] = "8"
                        $res[2] = "stopForce"
                    }
                }
                for ($i=0; $i -lt $res1.count; $i++) {
                     $res[$i+3]=$res1[$i].value
                }
            } else {
                $res[0] = "0"  
            }
        } else {
            $res = New-Object string[] 1
            $res[0] = "0"  
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
    function cargaDatosMaquinas ($maquinas) {
        $dataGridView1.Rows.Clear()
        if ($rbDes.Checked -eq "True") { $res = "D" }
        if ($rbInt.Checked) { $res ="Q" }
        if ($rbPro.Checked) { $res ="P"} 
        if ($rbAll.Checked) { $res ="A"} 
        if ($res -eq "D" -or $res -eq "Q" -or $res -eq "P" -or $res -eq "A") {
            foreach ($a in $maquinas.Maquinas.Dato) {
                # $sal = $a.Activa + "#" + $a.Server + "#" + $a.Grupo  + "#" + $a.Observaciones 
                $maqALL=$a
                # if ($a.Activa -eq "@SI") {
                    $maq=$a.Server
                    if ($res -eq "A") {
                          $dataGridView1.Rows.Add($maq)
                    } else {                       
                        if ($res -eq "D") {
                            if ( $maq.substring(0,1) -eq "D" -or $maq.substring(0,1) -eq "T" ) { 
                                 $dataGridView1.Rows.Add($maq)
                            }
                        } else {
                            if ( $maq.substring(0,1) -eq $res) { 
                                 $dataGridView1.Rows.Add($maq)
                            }
                        }
                    }        
                 #}
            }
            write-host $dataGridView1
        }
    }
    #
    # ----------------------
    # - FUNCTIONS - STARTS -
    # ----------------------
    #
    Function SNR ([string]$r) { return $r.ToString().Split("_")[1] }
    #
    # Comprobamos si exite el fichero que pasamos como parametro
    Function existeFile ([string]$r) { return (Test-Path $r) }
    Exit 0