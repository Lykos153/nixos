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
        $env.VAULT_TOKEN = (vault login -method=ldap -token-only username=silvio.ankermann)
      }
    '';
  };
}
