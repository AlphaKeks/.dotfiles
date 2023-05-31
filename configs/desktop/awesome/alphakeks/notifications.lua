-- https://GitHub.com/AlphaKeks/.dotfiles

ruled.notification.connect_signal("request::rules", function()
  ruled.notification.append_rule({
    rule = {},
    properties = {
      screen = awful.screen.preferred,
      implicit_timeout = 5,
    },
  })
end)

naughty.connect_signal("request::display", function(notification)
  naughty.layout.box({ notification = notification })
end)

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
