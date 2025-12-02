FROM debian:bookworm

# Install dependencies for building rsgain
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    pkg-config \
    libebur128-dev \
    libtag1-dev \
    libavformat-dev \
    libavcodec-dev \
    libswresample-dev \
    libavutil-dev \
    libfmt-dev \
    libinih-dev \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Clone rsgain repo
RUN git clone https://github.com/complexlogic/rsgain.git /rsgain

# Build rsgain
WORKDIR /rsgain
RUN mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install

# Clean up build files
RUN rm -rf /rsgain

# Create script to run rsgain
COPY run_rsgain.sh /usr/local/bin/run_rsgain.sh
RUN chmod +x /usr/local/bin/run_rsgain.sh

# Create entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create volume directory
VOLUME /music

# Set environment variables with defaults
ENV MODE=easy
ENV OPTIONS=""
ENV SCHEDULE="0 0 * * 0"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]