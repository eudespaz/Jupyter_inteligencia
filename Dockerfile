FROM python:3.9

LABEL maintainer="eudes.paz@kurier.com.br"

COPY . /app
COPY sources.list /etc/apt/
WORKDIR /app

RUN apt-get update \
&& apt-get install -y ffmpeg \
wget \
git \
libsm6 \
libxext6 \
tesseract-ocr \
libopenjp2-7-dev \
libgdk-pixbuf2.0-dev \
cmake \
checkinstall \
poppler-utils \
g++ \
autoconf \
libfontconfig1-dev \
pkg-config \
libjpeg-dev \
gnome-common \
libglib2.0-dev \
gtk-doc-tools \
libyelp-dev \
yelp-tools \
gobject-introspection \
libsecret-1-dev \
libnautilus-extension-dev

COPY por.traineddata /usr/share/tesseract-ocr/4.00/tessdata/

RUN apt-get build-dep libpoppler-cpp-dev -y

RUN wget https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz \
&& tar -xf poppler-data-0.4.12.tar.gz \
&& cd poppler-data-0.4.12 \
&& make install \
&& cd .. \
&& wget https://poppler.freedesktop.org/poppler-0.48.0.tar.xz \
&& tar -xf poppler-0.48.0.tar.xz \
&& cd poppler-0.48.0 \
&& ./configure \
&& make \
&& make install

RUN ln -s /usr/local/lib/libpoppler.so.64 /usr/lib/libpoppler.so.64

RUN pip install -U pip
RUN pip install -U jupyter scikit-learn nltk pandas matplotlib numpy spacy pdfminer3k pypdf2 slate3k pyodbc requests opencv-python pytesseract pdf2image opencv-python ray

CMD [ "jupyter", "notebook","--ip","0.0.0.0", "--port", "8890", "--no-browser", "--allow-root" ]
