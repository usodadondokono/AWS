FROM nvidia/cuda:8.0-cudnn6-devel

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install minimum 
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends wget bzip2 ca-certificates \
            libglib2.0-0 libxext6 libsm6 libxrender1 \
            git mercurial subversion

# Install miniconda 
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.1.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

# Install python and libraries
ARG python_version=3.6
ENV PATH /opt/conda/bin:$PATH
RUN conda install -y python=${python_version}
RUN pip install ipdb pytest pytest-cov python-coveralls coverage==3.7.1 pytest-xdist pep8 pytest-pep8 pydot_ng && \
    pip install jupyter Pillow scikit-learn notebook pandas matplotlib nose pyyaml six h5py && \
    conda clean -yt

RUN apt-get install -y vim
 
RUN mkdir /root/.jupyter
RUN echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = 'sha1:06098785498a:fb0c37e1aa37c0d31449f023485a67a83e5064a4'" >> /root/.jupyter/jupyter_notebook_config.py

RUN pip install lightgbm
RUN conda install -y pytorch torchvision cuda80 -c soumith

# port for jupyter notebook
EXPOSE 8888

WORKDIR /root 
