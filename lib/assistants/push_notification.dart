import "package:googleapis_auth/auth_io.dart" ;
import "package:http/http.dart" as http;

// Use service account credentials to obtain oauth credentials.
Future<String> obtainCredentials() async {
  var accountCredentials = ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "friendly-folio-425114-v9",
  "private_key_id": "4dc5b67caf9e18f430129b4e4756fc77583084b5",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDX/eViBZhNxMuQ\nmjGIQY51+iH7T1x6PfN/GJ2mMu5YnPwEWHJvK4SlSBYcx1DLeNkSMb01Rin6QtFb\nku/1EB/0Dpb/GrT2S/WgvlTGd0MEn/3SdmJujycBANgIZjB9Ua1ZWa866YmwQAi/\nlcNby40yDQIvyC1rDHHb/7/L8IJ1HbJ0OOL61C5Jco3cKDpq/tcsEsjj8KYZX6dm\nZ3Vp0yVSURB3wUysNio0Od7LJJoeQxOQuZ3SsTuLBjzSfeuM0ucOXE+0uTHLOLom\ntaVnrXRLwlfiM7CBKNJDVUNMSWAlS2G33154NsvNXHfGD0lrF34zvhbAn4V5Nyxq\n/9A9ITsnAgMBAAECggEAAWJUz7V+llT+P215SwUH0g9tjLsrBUcMS461FvoAophS\n8IYwdNXcO6hxRuRYrO8BOvweFU9ItO7++c91RW32hfx448S6qX5y8R+r0oVo89t8\n2HgJrulHSNrcgANlgwiLwL8mlmd/88MKdprkhidj6+s3ewwGFNaP9cEoEcCke33u\nDqCA4QdFI3mxi8GrJcEURdYQ9MYx005ESpWULupbhfp3VtZEBgieF6uFp8Z7K5VU\nv9Yw5aZIATPEp0nisaUXr3m1VTyCsEQ4UW2H48fb0p5bq7QNEhTeSbpl4Qhy8Lbp\nUf1LkmB2CkFYz9FBSYBUwoIna4yQvlhnmMxNGCvGvQKBgQD9fgkuT5FrWiBlD2kx\nbgn3DR69A7amxh32v5qk1xNtTpdoKnBpW/TWgUTNrpCVs7qICZLKo4BAGqv5PdrI\nHa6STQH9GUs0uTnPgmbb16yV68NdXTRG71BaYxFVpbJtmlHHnYpv5vkM9YAu5p55\nCdsVwQItHjP1J7B3WC6UUVsvVQKBgQDaIOQLTDP57t4T6GL6NVjBlir67FgJ2VdF\nPlaqJ/XUB3XyBKjpcRqK55jXhgWOKCTEi7AjwyK077qlQYPmWfSHnNf01t4/k8gX\n+3ptwiQkfS5Lbc565bvqhfjVIYEStuHqTamESlUICeDDAjeKaQjUgtCJvK0caWyR\nKi+6h9RoiwKBgQCsFYWSBL4JjJN1R7L3tWXaavO1CPJT4SayPXxz7vXnPHUYZ8cM\nHzrk67iTkK/ikLJOa4FVQw1rdy/L8au2MkAyXUi+Uw906VFPh4zgLVeiJvznQsCc\nbxWzZpF7/RJVyW8+/bnfIYNswrSUIkbukDxEVlRt4JURFjJ7skdctKYcSQKBgCOc\n8x6VFndb9I4zhtVrGE6jAelt5QHWplT71JJ7a7tubGdTM3DJspezMFUf4JBRJY+h\nbuSn22bHLSYGCE73qODrTqb+3dJrgmPH/zkkVVpPxdsy1l9iWsfzj6jci4JOsZvb\nii27JR7m3fd4yTCj7Xkk0n9qeqkE3WDmDlzaCGf5AoGATDzLtCLJfTUyngq7uR1T\nkJZQ6hLYGv4BTh3xoXAFOJZa3/hNNRnF3d6K/6OQEztoYKfCYX2fxLopI7WHHvoj\na5Kw/OCr3UWHQLRZlnhgg3Dem60FBpnlYOX7WMJqswLSJAgBaRz4kaBYoyMjbl9/\njfC1JllCDceNHmIz7BOWPbE=\n-----END PRIVATE KEY-----\n",
  "client_email": "messeging@friendly-folio-425114-v9.iam.gserviceaccount.com",
  "client_id": "106594779452704673358",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/messeging%40friendly-folio-425114-v9.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
);
List<String> scopes = [
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
];

  http.Client client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "friendly-folio-425114-v9",
  "private_key_id": "4dc5b67caf9e18f430129b4e4756fc77583084b5",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDX/eViBZhNxMuQ\nmjGIQY51+iH7T1x6PfN/GJ2mMu5YnPwEWHJvK4SlSBYcx1DLeNkSMb01Rin6QtFb\nku/1EB/0Dpb/GrT2S/WgvlTGd0MEn/3SdmJujycBANgIZjB9Ua1ZWa866YmwQAi/\nlcNby40yDQIvyC1rDHHb/7/L8IJ1HbJ0OOL61C5Jco3cKDpq/tcsEsjj8KYZX6dm\nZ3Vp0yVSURB3wUysNio0Od7LJJoeQxOQuZ3SsTuLBjzSfeuM0ucOXE+0uTHLOLom\ntaVnrXRLwlfiM7CBKNJDVUNMSWAlS2G33154NsvNXHfGD0lrF34zvhbAn4V5Nyxq\n/9A9ITsnAgMBAAECggEAAWJUz7V+llT+P215SwUH0g9tjLsrBUcMS461FvoAophS\n8IYwdNXcO6hxRuRYrO8BOvweFU9ItO7++c91RW32hfx448S6qX5y8R+r0oVo89t8\n2HgJrulHSNrcgANlgwiLwL8mlmd/88MKdprkhidj6+s3ewwGFNaP9cEoEcCke33u\nDqCA4QdFI3mxi8GrJcEURdYQ9MYx005ESpWULupbhfp3VtZEBgieF6uFp8Z7K5VU\nv9Yw5aZIATPEp0nisaUXr3m1VTyCsEQ4UW2H48fb0p5bq7QNEhTeSbpl4Qhy8Lbp\nUf1LkmB2CkFYz9FBSYBUwoIna4yQvlhnmMxNGCvGvQKBgQD9fgkuT5FrWiBlD2kx\nbgn3DR69A7amxh32v5qk1xNtTpdoKnBpW/TWgUTNrpCVs7qICZLKo4BAGqv5PdrI\nHa6STQH9GUs0uTnPgmbb16yV68NdXTRG71BaYxFVpbJtmlHHnYpv5vkM9YAu5p55\nCdsVwQItHjP1J7B3WC6UUVsvVQKBgQDaIOQLTDP57t4T6GL6NVjBlir67FgJ2VdF\nPlaqJ/XUB3XyBKjpcRqK55jXhgWOKCTEi7AjwyK077qlQYPmWfSHnNf01t4/k8gX\n+3ptwiQkfS5Lbc565bvqhfjVIYEStuHqTamESlUICeDDAjeKaQjUgtCJvK0caWyR\nKi+6h9RoiwKBgQCsFYWSBL4JjJN1R7L3tWXaavO1CPJT4SayPXxz7vXnPHUYZ8cM\nHzrk67iTkK/ikLJOa4FVQw1rdy/L8au2MkAyXUi+Uw906VFPh4zgLVeiJvznQsCc\nbxWzZpF7/RJVyW8+/bnfIYNswrSUIkbukDxEVlRt4JURFjJ7skdctKYcSQKBgCOc\n8x6VFndb9I4zhtVrGE6jAelt5QHWplT71JJ7a7tubGdTM3DJspezMFUf4JBRJY+h\nbuSn22bHLSYGCE73qODrTqb+3dJrgmPH/zkkVVpPxdsy1l9iWsfzj6jci4JOsZvb\nii27JR7m3fd4yTCj7Xkk0n9qeqkE3WDmDlzaCGf5AoGATDzLtCLJfTUyngq7uR1T\nkJZQ6hLYGv4BTh3xoXAFOJZa3/hNNRnF3d6K/6OQEztoYKfCYX2fxLopI7WHHvoj\na5Kw/OCr3UWHQLRZlnhgg3Dem60FBpnlYOX7WMJqswLSJAgBaRz4kaBYoyMjbl9/\njfC1JllCDceNHmIz7BOWPbE=\n-----END PRIVATE KEY-----\n",
  "client_email": "messeging@friendly-folio-425114-v9.iam.gserviceaccount.com",
  "client_id": "106594779452704673358",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/messeging%40friendly-folio-425114-v9.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
), scopes);
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
          accountCredentials, scopes, client);

  client.close();
  print("credentials.accessToken.data");
  print(credentials.accessToken.data);

  return credentials.accessToken.data;
}
