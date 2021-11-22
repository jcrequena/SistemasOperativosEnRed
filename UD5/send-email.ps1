$EmailPropio = "admin@smr.local";
$EmailDestino = "juancarlos.requena@ieselcaminas.org"
$Asunto = "El asunto del email"
$Mensaje = "El cuerpo del mensaje"
$ServidorSMTP = "smtp.smr.local"
$ClienteSMTP = New-Object Net.Mail.SmtpClient($ServidorSMTP, 587)
$ClienteSMTP.EnableSsl = $true
$ClienteSMTP.Credentials = New-Object System.Net.NetworkCredential("usuario", "contraseña");
$ClienteSMTP.Send($EmailPropio, $EmailDestino, $Asunto, $Mensaje)



$EmailDestinatario = "juancarlos.requena@ieselcaminas.org"
$EmailEmisor = "admin@smr.local"
$Asunto = "Prueba envío mail desde PowerShell"
$CuerpoEnHTML = "Esto es una <b>prueba</b> de envío de correo electrónico desde PowerShell</a>"
$SMTPServidor = "smtp.gmail.com"
$RutaNombreFicheroAdjunto = "C:\Windows\System32\winevt\Logs\Security.evtx"
$CodificacionCaracteres=[System.Text.Encoding]::UTF8
try
{
  $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
  $SMTPAdjunto = New-Object System.Net.Mail.Attachment($RutaNombreFicheroAdjunto)
  $SMTPMensaje.Attachments.Add($SMTPAdjunto)
  $SMTPMensaje.IsBodyHtml = $true
  $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
  $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
  $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
  $SMTPCliente.EnableSsl = $true
  $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "contraseña");
  $SMTPCliente.Send($SMTPMensaje)
  Write-Output "Mensaje enviado correctamente"
}  
catch
{
  Write-Error -Message "Error al enviar correo electrónico"
}





#Set-ExecutionPolicy RemoteSigned

#Lo que hay que hacer en el Programador de tareas es:
#Seleccionar como acción a realizar "Iniciar un programa" y en el siguiente paso seleccionar el fichero a ejecutar

#Fichero de eventos/Logs del sistema sobre seguridad
#C:\Windows\System32\winevt\Logs\Security.evtx
