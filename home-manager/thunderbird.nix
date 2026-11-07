{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles."default" = {
      isDefault = true;
      accountsOrder = [
        "Personal"
        "Business"
        "Apps"
        "UTC"
        "Junior UTC"
      ];
      settings = {
        "calendar.week.start" = 1;
      };
    };
  };

  accounts.email.accounts =
    let
      googleImap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };
      googleSmtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls.enable = true;
        tls.useStartTls = true;
      };
      oauthSettings = id: {
        # 10 = OAuth2
        "mail.server.server_${id}.authMethod" = 10;
        "mail.smtpserver.smtp_${id}.authMethod" = 10;
      };
    in
    {
      "Personal" = {
        primary = true;
        realName = "Alexandre Borghi";
        address = "alexandre@aborghi.fr";
        userName = "borghi.alexandre.12@gmail.com";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings =
            id:
            {
              "mail.identity.id_${id}.reply_to" = "alexandre@aborghi.fr";
            }
            // oauthSettings id;
        };
      };
      "Apps" = {
        realName = "Alexandre Borghi";
        address = "apps@aborghi.fr";
        userName = "alex.apps.12@gmail.com";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings =
            id:
            {
              "mail.identity.id_${id}.reply_to" = "apps@aborghi.fr";
            }
            // oauthSettings id;
        };
      };
      "Business" = {
        realName = "Alexandre Borghi";
        address = "contact@aborghi.fr";
        userName = "aborghi.pro@gmail.com";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings =
            id:
            {
              "mail.identity.id_${id}.reply_to" = "contact@aborghi.fr";
            }
            // oauthSettings id;
        };
      };
      "UTC" = {
        realName = "Alexandre Borghi";
        address = "alexandre.borghi@etu.utc.fr";
        userName = "borghial";

        imap = {
          host = "imaps.utc.fr";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtps.utc.fr";
          port = 465;
          tls.enable = true;
        };

        thunderbird.enable = true;
      };
      "Junior UTC" = {
        realName = "Alexandre Borghi";
        address = "aborghi@juniorutc.fr";
        userName = "aborghi@juniorutc.fr";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings = id: oauthSettings id;
        };
      };
    };
  accounts.calendar.accounts = {
    "Personal" = {
      remote = {
        url = "https://cloud.aborghi.fr/remote.php/dav/calendars/alex/personal-2";
        userName = "alex";
        type = "caldav";
      };
      thunderbird = {
        enable = true;
        color = "#1877f2";
      };
    };
    "Contact birthdays" = {
      remote = {
        url = "https://cloud.aborghi.fr/remote.php/dav/calendars/alex/contact_birthdays";
        userName = "alex";
        type = "caldav";
      };
      thunderbird = {
        enable = true;
        readOnly = true;
        color = "#ffdf00";
      };
    };
  };
  accounts.contact.accounts = {
    "Contacts" = {
      remote = {
        url = "https://cloud.aborghi.fr/remote.php/dav/addressbooks/users/alex/contacts";
        userName = "alex";
        type = "carddav";
      };
      thunderbird.enable = true;
    };
  };
}
