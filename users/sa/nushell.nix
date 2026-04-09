{pkgs, ...}: {
  programs.nushell = {
    extraConfig = ''
      def --env cl [] {cd (ls ~/clusters/*/* | get name | to text | ${pkgs.skim}/bin/sk)}
      def --env gq [] {cd (fd -H "^.git$" ~/ghq/ | lines | path parse | get parent | to text | ${pkgs.skim}/bin/sk)}

      def --env "vault decode-root" [] {
        let encoded = (input -s "Encoded token: ")
        let otp = (input -s "\nOTP: ")
        $env.VAULT_TOKEN = (vault operator generate-root -decode $encoded -otp $otp)
      }

      def --env "vault ldap-login" [] {
        let cacert_args = if ("VAULT_CACERT" in $env) { [--cacert $env.VAULT_CACERT] } else { [] }
        $env.VAULT_TOKEN = (
          {password: (pass ldap)}
            | to json
            | curl ...$cacert_args -X POST $"($env.VAULT_ADDR)/v1/auth/ldap/login/silvio.ankermann" -H "Content-Type: application/json" --silent --data @-
            | from json
            | get auth.client_token
        )
      }
    '';
  };
}
