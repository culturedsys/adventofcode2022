use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    try
      let input = Input.lines(6, env).next()?
      env.out.print(Locator.locate(input, 14)?.string())
    else
      env.err.print("Parse error")
    end