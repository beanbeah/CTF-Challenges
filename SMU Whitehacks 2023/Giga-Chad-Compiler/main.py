import asyncio
import logging
import os

import discord

# variables
task_counter = 0
current_exec = []

logging.basicConfig(filename="/home/ubuntu/output_bot.log", level=logging.INFO)

def init():
    # check if docker is installed
    if os.system("sudo docker -v") != 0:
        logging.error("Docker is not installed")
        exit(1)

    # add necessary files
    os.system("sudo echo WH2023{g1gaChAds_wr1t3_c0d3_1n_ASM_n0t_C} > /root/flag.txt")
    os.system("sudo mkdir /home/ubuntu/container")
    os.system("sudo wget -O /home/ubuntu/container/build_run.sh https://gist.githubusercontent.com/beanbeah/78e29c07f5c5280ece585dd15d1b6020/raw/cfa09b75dbc778d2f32fddc45661a78ec4b6ab28/build_run.sh")
    os.system("sudo wget -O /home/ubuntu/container/Dockerfile https://gist.githubusercontent.com/beanbeah/d8b34b9c5ac65642db59db82774ad082/raw/7794a8bc2e8449c9378d922cd7390f5795dfe603/Dockerfile")

    # remove main.py to prevent token leak
    os.system("sudo rm /home/ubuntu/main.py")

    # get output of docker ps, and kill all containers
    output = os.popen("sudo docker ps -a").read()
    #skip the first line
    for line in output.splitlines()[1:]:
        if line != "":
            os.system("sudo docker kill " + line.split()[0])
            os.system("sudo docker rm " + line.split()[0])

    # build the docker image
    os.system("sudo docker build -t code-runner /home/ubuntu/container")

    os.system("sudo rm /home/ubuntu/container/build_run.sh")
    os.system("sudo rm /home/ubuntu/container/Dockerfile")


async def exec_code(userId, code):
    # store the code in a temp file with the user id as the name
    filename = f"/tmp/{userId}"
    with open(filename, "wb") as f:
        f.write(code)

    # run the docker container and store the output in a string
    output = os.popen(
        f"sudo cat {filename} | sudo docker run --rm -i --cap-add=DAC_READ_SEARCH --cap-drop=SYS_CHROOT --cap-drop=DAC_OVERRIDE --network none --name {userId} --stop-timeout 5 code-runner"
    ).read()

    # remove the temp file
    os.remove(filename)

    return output


BOT_TOKEN = ""
bot = discord.Bot()

@bot.check
async def disable_guild(ctx):
    return ctx.guild is None

@bot.slash_command(description="Upload C file to be compiled")
async def compile(ctx, code: discord.Attachment):
    global task_counter
    global current_exec

    embed = discord.Embed()

    # check if the user is already executing code
    if ctx.author.id in current_exec:
        embed.description = "You are already executing code."
        embed.colour = discord.Colour.red()
        await ctx.respond(embed=embed, ephemeral=True)
    else:
        current_exec.append(ctx.author.id)
        code = await code.read()

        embed.title = "Submission successful"
        embed.description = f"You will receive your results soon. (no. {task_counter+1} in queue)"
        embed.colour = discord.Colour.blurple()
        await ctx.respond(embed=embed)

        # wait for less than 5 containers running
        while task_counter > 5:
            asyncio.sleep(1.0)
        try:
            # run the code and get the output
            task_counter += 1
            output = await exec_code(ctx.author.id, code)
        except:
            task_counter -= 1
            current_exec.remove(ctx.author.id)

            embed.title = "Error"
            embed.description = "An unexpected error occurred, please try again."
            embed.colour = discord.Colour.red()
            await ctx.respond(embed=embed, ephemeral=True)
        else:
            task_counter -= 1
            current_exec.remove(ctx.author.id)

            embed.title = "Output"
            embed.description = output[-2048:]
            embed.colour = discord.Colour.green()
            await ctx.respond(embed=embed)


@bot.slash_command()
async def reset(ctx):
    if ctx.author.id == 638306658858172416 or ctx.author.id == 412810454063382529:
        # get output of docker ps, and kill all containers
        try:
            output = os.popen("sudo docker ps -a").read()
            for line in output.splitlines():
                if line != "":
                    os.system("sudo docker kill " + line.split()[0])
                    os.system("sudo docker rm " + line.split()[0])

            # remove all temp files
            os.system("sudo rm /tmp/*")

            await ctx.respond("Reset OK")
        except:
            await ctx.respond("Reset failed")
    else:
        await ctx.respond("You are not authorized to use this command", ephemeral=True)

init()
bot.run(BOT_TOKEN)
