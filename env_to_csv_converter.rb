require 'tty-spinner'

array_aux = []

def duplicate_env?(env, array_aux)
  array_aux.any? { |item| item[:name] == env[:name] }
end

spinners = TTY::Spinner::Multi.new("[:spinner] convertendo para csv")

File.foreach("./env_next.txt") do |line|
  next if line.strip.empty?

  str = line.split(" ")

  env = {
    prefix: str[0],
    name: str[1],
    value: str[2]
  }

  unless duplicate_env?(env, array_aux)
    array_aux.push(env)

    # Simulate some work here
    spinner = spinners.register("converting_#{env[:name]}", format: :pulse_2)
    spinner.auto_spin

    sleep(0.2)

    spinner.success("#{env[:name]} converted")

    File.open("./next.csv", "a") { |f| f.write "website/config/next/#{env[:name]}, SecureString, #{env[:value]}\n" }
  end
end

spinners.stop
