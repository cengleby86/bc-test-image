# Use Red Hat Universal Base Image 9 (UBI9)
FROM registry.access.redhat.com/ubi9/ubi:latest

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Install necessary utilities
RUN yum -y update && yum install -y gcc openssl-devel bzip2-devel libffi-devel wget make

# Install Python 3.10
RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz && \
    tar xzf Python-3.10.0.tgz && \
    cd Python-3.10.0 && \
    ./configure --enable-optimizations && \
    make altinstall

# Install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.10 get-pip.py

# Install pandas and pyspark
RUN pip3 install pandas==1.5.3 pyspark==3.4.1

# Copy the jupyter notebook configuration file
COPY jupyter_notebook_config.py /root/.jupyter/

# Expose the jupyter notebook port
EXPOSE 8888

USER 1001

# Start the jupyter notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root"]
