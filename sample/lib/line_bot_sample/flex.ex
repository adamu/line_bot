defmodule LineBotSample.Flex do
  def make_flex_message do
    %LineBot.Message.Flex{
      altText: "Your Brown Store Receipt",
      contents: %LineBot.Message.Flex.Bubble{
        body: %LineBot.Message.Flex.Box{
          layout: "vertical",
          contents: [
            %LineBot.Message.Flex.Text{
              text: "RECEIPT",
              weight: "bold",
              color: "#1DB446",
              size: "sm"
            },
            %LineBot.Message.Flex.Text{
              text: "Brown Store",
              weight: "bold",
              size: "xxl",
              margin: "md"
            },
            %LineBot.Message.Flex.Text{
              text: "Miraina Tower, 4-1-6 Shinjuku, Tokyo",
              size: "xs",
              color: "#aaaaaa",
              wrap: true
            },
            %LineBot.Message.Flex.Separator{margin: "xxl"},
            %LineBot.Message.Flex.Box{
              layout: "vertical",
              margin: "xxl",
              spacing: "sm",
              contents: [
                %LineBot.Message.Flex.Box{
                  layout: "horizontal",
                  contents: [
                    %LineBot.Message.Flex.Text{
                      text: "Energy Drink",
                      size: "sm",
                      color: "#555555",
                      flex: 0
                    },
                    %LineBot.Message.Flex.Text{
                      text: "$2.99",
                      size: "sm",
                      color: "#111111",
                      align: "end"
                    }
                  ]
                },
                %LineBot.Message.Flex.Box{
                  layout: "horizontal",
                  contents: [
                    %LineBot.Message.Flex.Text{
                      text: "Chewing Gum",
                      size: "sm",
                      color: "#555555",
                      flex: 0
                    },
                    %LineBot.Message.Flex.Text{
                      text: "$0.99",
                      size: "sm",
                      color: "#111111",
                      align: "end"
                    }
                  ]
                },
                %LineBot.Message.Flex.Box{
                  layout: "horizontal",
                  contents: [
                    %LineBot.Message.Flex.Text{
                      text: "Bottled Water",
                      size: "sm",
                      color: "#555555",
                      flex: 0
                    },
                    %LineBot.Message.Flex.Text{
                      text: "$3.33",
                      size: "sm",
                      color: "#111111",
                      align: "end"
                    }
                  ]
                }
              ]
            },
            %LineBot.Message.Flex.Separator{margin: "xxl"},
            %LineBot.Message.Flex.Box{
              layout: "horizontal",
              margin: "xxl",
              contents: [
                %LineBot.Message.Flex.Text{text: "ITEMS", size: "sm", color: "#555555"},
                %LineBot.Message.Flex.Text{text: "3", size: "sm", color: "#111111", align: "end"}
              ]
            },
            %LineBot.Message.Flex.Box{
              layout: "horizontal",
              margin: "xxl",
              contents: [
                %LineBot.Message.Flex.Text{text: "TOTAL", size: "sm", color: "#555555"},
                %LineBot.Message.Flex.Text{
                  text: "$7.31",
                  size: "sm",
                  color: "#111111",
                  align: "end"
                }
              ]
            },
            %LineBot.Message.Flex.Box{
              layout: "horizontal",
              margin: "xxl",
              contents: [
                %LineBot.Message.Flex.Text{text: "CASH", size: "sm", color: "#555555"},
                %LineBot.Message.Flex.Text{
                  text: "$8.0",
                  size: "sm",
                  color: "#111111",
                  align: "end"
                }
              ]
            },
            %LineBot.Message.Flex.Box{
              layout: "horizontal",
              margin: "xxl",
              contents: [
                %LineBot.Message.Flex.Text{text: "CHANGE", size: "sm", color: "#555555"},
                %LineBot.Message.Flex.Text{
                  text: "$0.69",
                  size: "sm",
                  color: "#111111",
                  align: "end"
                }
              ]
            },
            %LineBot.Message.Flex.Separator{margin: "xxl"},
            %LineBot.Message.Flex.Box{
              layout: "horizontal",
              margin: "md",
              contents: [
                %LineBot.Message.Flex.Text{
                  text: "PAYMENT ID",
                  size: "xs",
                  color: "#aaaaaa",
                  flex: 0
                },
                %LineBot.Message.Flex.Text{
                  text: "#743289384279",
                  size: "xs",
                  color: "#aaaaaa",
                  align: "end"
                }
              ]
            }
          ]
        },
        styles: %LineBot.Message.Flex.BubbleStyle{
          footer: %LineBot.Message.Flex.BubbleStyleBlock{
            separator: true
          }
        }
      }
    }
  end
end
