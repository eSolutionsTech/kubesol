# Keycloak

Keycloak is an open-source identity and access management solution for modern applications and services. It provides comprehensive support for single sign-on (SSO), identity federation, and user management, enabling secure authentication and authorization across various platforms. Keycloak offers out-of-the-box integration with various authentication protocols like OAuth2, OpenID Connect, and SAML, making it easy to implement secure user authentication and authorization. It also features a user-friendly admin console, customizable login pages, and support for user self-service features.

Official URLs for Keycloak:  
https://www.keycloak.org/  
https://www.keycloak.org/documentation  
https://github.com/keycloak/keycloak  


## Keycloak web interface

To use the keycloak web interface. The URL is something like `https://keycloak.<<ext_dns_name>>`, 
you can get the exact address with `kubectl -n keycloak get ingress`.

Retrieve the first admin password with:

```
kubectl get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 -d
```

![](keycloak.png "")
