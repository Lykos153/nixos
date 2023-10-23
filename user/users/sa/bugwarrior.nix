{pkgs, ...}: {
  home.packages = with pkgs; [
    lykos153.bugwarrior
  ];
  xdg.configFile."bugwarrior/bugwarrior.toml".source = let
    gitlab = {
      service = "gitlab";
      host = "gitlab.com";
      login = "Lykos153";
      token = "@oracle:eval:pass gitlab/bugwarrior_token";
      include_repos = "yaook/k8s";
      description_template = "{{gitlabtitle}}";
      owned = true;
    };
  in
    (pkgs.formats.toml {}).generate "bugwarrior.toml" {
      general = {
        targets = [
          "redmine"
          "gitlab-assigned"
          "gitlab-review"
          "gitlab-review-assigned"
          "gitlab-ch"
        ];
        taskrc = "~/.config/task/taskrc"; # from variable?
        inline_links = false;
        annotation_links = true;
        annotation_comments = false;
      };
      redmine = {
        service = "redmine";
        url = "https://redmine.cloudandheat.com";
        key = "@oracle:eval:pass redmine_token"; # from variable?
        only_if_assigned = true;
      };
      gitlab-assigned =
        gitlab
        // {
          only_if_assigned = "Lykos153";
          project_template = "yaook.k8s.mrs";
        };
      gitlab-review =
        gitlab
        // {
          include_issues = false;
          merge_request_query = "projects/29738620/merge_requests?state=opened&labels=Needs review&not[author_username]=Lykos153&wip=no";
          project_template = "yaook.k8s.review";
          description_template = "Review {{gitlabtitle}}";
        };
      gitlab-review-assigned =
        gitlab
        // {
          include_issues = false;
          merge_request_query = "projects/29738620/merge_requests?state=opened&reviewer_username=Lykos153&wip=no";
          project_template = "yaook.k8s.review";
          description_template = "Review {{gitlabtitle}}";
        };
      gitlab-ch = {
        service = "gitlab";
        host = "gitlab.cloudandheat.com";
        login = "silvio.ankermann";
        token = "@oracle:eval:pass gitlab_cah/bugwarrior_token";
        merge_request_query = "merge_requests?state=opened&assignee_username=silvio.ankermann";
        exclude_repos = ["lcm/managed-k8s"];
        include_issues = false;
        only_if_assigned = "silvio.ankermann";
        membership = true;
      };
    };
}
