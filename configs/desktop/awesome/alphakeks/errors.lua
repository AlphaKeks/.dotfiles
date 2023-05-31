-- https://GitHub.com/AlphaKeks/.dotfiles

local presets = naughty.config.presets
local errors = awesome.startup_errors

if errors then
  local errors = tostring(errors)

  naughty.notify({
    preset = presets.critical,
    title = "Errors occurred during startup.",
    text = errors,
  })

  local write_errors = "echo '" .. errors .. "' >> /tmp/awesome.log"

  try(write_errors, "Failed to write error log to /tmp/awesome.log")
end

do
  local in_error = false

  awesome.connect_signal("debug::error", function(error)
    if in_error then
      return
    end

    in_error = true

    naughty.notify({
      preset = presets.critical,
      title = "ERROR",
      text = tostring(error),
    })

    in_error = false
  end)
end

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
