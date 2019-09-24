Lockr is a file transfer service that achieves high security, yet with simple operations.
<br>
You no longer need to encrypt your file before sending it.

## End-to-end encryption (E2EE)

In many conventional file transfer services, there are points where files are handled without being encrypted, so there is a risk of information leaking from inside the operator or by hacking.

Lockr encrypts the file in the sender's browser with AES-256 before sending it to the server, and decrypts it in the recipient's browser. The encryption key is never sent to the server, so even we operators cannot know the contents of the file.

## Double encryption

Data encrypted on the client side is encrypted again on the server side with AES-256. The encryption key is generated for each upload and discarded when the file is deleted. For this reason, once a file is deleted, the original data cannot be retrieved even if the deleted file can be restored.

## 5GB for free

Up to 5GB can be used per user.
 
## Broad browser support

In addition to all modern browsers, Internet Explorer 11 is supported.

<small>Some browsers may not be able to download very large files.</small>

## Automatic expiration

When uploading, you can set the file expiration date and the maximum number of downloads. Files are deleted automatically when they expire or when the maximum number of downloads has been reached.

## Password protection

You can set a password when uploading. The download link is cryptographically unpredictable, so you don't need to set a password unless the link is likely to be seen by a third party.

If you have to share the link in a possibly insecure manner, you can maintain security by setting a password and sending it separately from the link. There is no point in sending the link and password over the same route.
