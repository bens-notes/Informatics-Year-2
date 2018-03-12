FROM debian:8

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \ 
    libglib2.0-0 libxext6 libsm6 libxrender1 \ 
    git mercurial subversion 

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \ 
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.4.10-Linux-x86_64.sh -O ~/miniconda.sh && \ 
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \ 
    rm ~/miniconda.sh 
    
RUN apt-get install -y curl grep sed dpkg && \ 
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \ 
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \ 
    rm tini.deb && \ 
    apt-get clean 
    
RUN apt-get install -y node

ADD environment.yml /home/environment.yml
RUN /opt/conda/bin/conda env update -f /home/environment.yml

ENV PATH /opt/conda/bin:$PATH 

RUN echo "source activate notes" >> run.sh
RUN echo "jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser" >> run.sh

ENTRYPOINT [ "/bin/bash", "run.sh" ]