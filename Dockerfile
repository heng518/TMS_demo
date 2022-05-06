FROM python:3.8.5
COPY . /app
WORKDIR /app
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y
RUN apt install libgl1-mesa-glx -y
RUN apt-get install 'ffmpeg'\
    'libsm6'\
    'libxext6'  -y

RUN apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    python3-opencv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m venv /opt/venv

RUN /opt/venv/bin/pip install --upgrade pip

# Install Jupyter
RUN /opt/venv/bin/pip install jupyter
RUN /opt/venv/bin/pip install ipywidgets
RUN /opt/venv/bin/jupyter nbextension enable --py widgetsnbextension

# Install JupyterLab
RUN /opt/venv/bin/pip install jupyterlab && /opt/venv/bin/jupyter serverextension enable --py jupyterlab

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 8888