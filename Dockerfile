# Use Red Hat Universal Base Image 9 (UBI9)
FROM registry.access.redhat.com/ubi9/ubi:latest

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Install necessary utilities
# RUN yum -y update && yum install -y gcc openssl-devel bzip2-devel libffi-devel wget make
RUN yum -y update && yum install -y gcc openssl-devel bzip2-devel libffi-devel wget make zlib-devel

# Install Python 3.10
RUN wget https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz && \
    tar xzf Python-3.10.6.tgz && \
    cd Python-3.10.6 && \
    ./configure --enable-optimizations && \
    make altinstall

# Install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.10 get-pip.py

# Install pandas and pyspark
RUN pip3 install virtualenv \
    && virtualenv venv --python python3.10 \
    && source venv/bin/activate \
    && pip3 install \
        pandas==1.5.3 \
        pyspark==3.4.1 \
        jupyter \
        ipykernel

# Expose the jupyter notebook port
EXPOSE 8888

USER 1001

# Start the jupyter notebook
CMD ["sh", "-c", "jupyter notebook --ip=0.0.0.0 --no-browser"]
