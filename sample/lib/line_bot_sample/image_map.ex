defmodule LineBotSample.Imagemap do
  def make_imagemap_message do
    %LineBot.Message.Imagemap{
      baseUrl: "https://adamu.github.io/images/rich/",
      altText: "Please select an option",
      baseSize: %{width: 1040, height: 1040},
      actions: [
        %LineBot.Message.Imagemap.Action.URI{
          linkUri: "https://store.line.me/family/manga/en",
          area: %{x: 0, y: 0, width: 512, height: 512}
        },
        %LineBot.Message.Imagemap.Action.URI{
          linkUri: "https://store.line.me/family/music/en",
          area: %{x: 512, y: 0, width: 512, height: 512}
        },
        %LineBot.Message.Imagemap.Action.URI{
          linkUri: "https://store.line.me/family/play/en",
          area: %{x: 0, y: 512, width: 512, height: 512}
        },
        %LineBot.Message.Imagemap.Action.Message{
          text: "Fortune!",
          area: %{x: 512, y: 512, width: 512, height: 512}
        }
      ]
    }
  end

  def make_imagemap_video_message do
    %LineBot.Message.Imagemap{
      baseUrl: "https://adamu.github.io/images/rich/",
      altText: "Please select an option",
      baseSize: %{width: 1040, height: 1040},
      video: %LineBot.Message.Imagemap.Video{
        originalContentUrl: "https://adamu.github.io/images/imagemap/video.mp4",
        previewImageUrl: "https://adamu.github.io/images/imagemap/preview.jpg",
        area: %{x: 0, y: 0, width: 512, height: 512},
        externalLink: %{linkUri: "https://line.me", label: "LINE"}
      },
      actions: [
        %LineBot.Message.Imagemap.Action.URI{
          linkUri: "https://store.line.me/family/manga/en",
          area: %{x: 0, y: 0, width: 512, height: 512}
        },
        %LineBot.Message.Imagemap.Action.URI{
          linkUri: "https://store.line.me/family/music/en",
          area: %{x: 512, y: 0, width: 512, height: 512}
        },
        %LineBot.Message.Imagemap.Action.URI{
          linkUri: "https://store.line.me/family/play/en",
          area: %{x: 0, y: 512, width: 512, height: 512}
        },
        %LineBot.Message.Imagemap.Action.Message{
          text: "Fortune!",
          area: %{x: 512, y: 512, width: 512, height: 512}
        }
      ]
    }
  end
end
