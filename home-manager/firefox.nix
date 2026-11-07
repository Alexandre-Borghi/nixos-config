{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "fr"
    ];
    profiles.default = {
      search = {
        default = "ddg";
        force = true;
        engines = {
          ddg = {
            name = "DuckDuckGo";
            urls = [
              {
                template = "https://duckduckgo.com";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
                definedAliases = [ "@np" ];
              }
            ];
          };
          google.metaData.hidden = true;
          bing.metaData.hidden = true;
          perplexity.metaData.hidden = true;
          qwant.metaData.hidden = true;
          startpage.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
        };
      };
      settings = {
        "sidebar.verticalTabs" = true;
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
        # Move sidebar to the right
        "sidebar.position_start" = false;
        "browser.newtabpage.activity-stream.widgets.weather.enabled" = false;
        # Disable newtabpage shortcuts
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.urlbar.suggest.topsites" = false;
        # Automatically enable extensions
        "extensions.autoDisableScopes" = 0;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
      ];
    };
    policies = {
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      SkipTermsOfUse = true;
    };
  };
}
