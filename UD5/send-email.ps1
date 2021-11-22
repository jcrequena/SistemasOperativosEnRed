$EmailPropio = "admin@smr.local";
$EmailDestino = "juancarlos.requena@ieselcaminas.org"
$Asunto = "El asunto del email"
$Mensaje = "El cuerpo del mensaje"
$ServidorSMTP = "smtp.smr.local"
$ClienteSMTP = New-Object Net.Mail.SmtpClient($ServidorSMTP, 587)
$ClienteSMTP.EnableSsl = $true
$ClienteSMTP.Credentials = New-Object System.Net.NetworkCredential("usuario", "contraseña");
$ClienteSMTP.Send($EmailPropio, $EmailDestino, $Asunto, $Mensaje)


#Lo que hay que hacer en el Programador de tareas es:
#Seleccionar como acción a realizar "Iniciar un programa" y en el siguiente paso seleccionar el fichero a ejecutar

