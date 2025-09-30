# Use lightweight Debian base
FROM debian:stable-slim

# Install dependencies: fortune, cowsay, netcat
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# Add /usr/games to PATH
ENV PATH="$PATH:/usr/games" 

# Copy script into container
WORKDIR /app
COPY wisecow.sh .

# Make script executable
RUN chmod +x wisecow.sh

# Expose the port
EXPOSE 4499

# Run the script
CMD ["./wisecow.sh"]

