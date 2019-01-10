$EmailPropio = "tuemaildegmail@gmail.com";
$EmailDestino = "jrequenav@iesmiralcamp.org";
$Asunto = "El asunto del email"
$Mensaje = "El cuerpo del mensaje"
$ServidorSMTP = "smtp.gmail.com"
$ClienteSMTP = New-Object Net.Mail.SmtpClient($ServidorSMTP, 587)
$ClienteSMTP.EnableSsl = $true
$ClienteSMTP.Credentials = New-Object System.Net.NetworkCredential("usuario", "contraseña");
$ClienteSMTP.Send($EmailPropio, $EmailDestino, $Asunto, $Mensaje)


#Lo que hay que hacer en el Programador de tareas es:
#Seleccionar como acción a realizar "Iniciar un programa" y en el siguiente paso escribir lo siguiente
#powershell -file "C:\rutadelscript\send-email.ps1"
