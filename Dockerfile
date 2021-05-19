FROM openjdk:8 as builder

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

RUN git clone https://github.com/brown-uk/dict_uk.git
RUN rm ./dict_uk/distr/hunspell/src/main/groovy/Hunspell.groovy
COPY ./Hunspell.groovy ./dict_uk/distr/hunspell/src/main/groovy

WORKDIR ./dict_uk/distr/hunspell
RUN ../../gradlew hunspell


ARG CRUNCYDATA_POSTGRES_IMAGE
ARG CRUNCYDATA_POSTGRES_TAG

FROM registry.developers.crunchydata.com/crunchydata/$CRUNCYDATA_POSTGRES_IMAGE:$CRUNCYDATA_POSTGRES_TAG

USER root

ARG SHARE_PATH

COPY ./tsearch_data/ukrainian.syn $SHARE_PATH/tsearch_data/ukrainian.syn
COPY --from=builder  /dict_uk/distr/hunspell/build/hunspell/uk_UA.dic $SHARE_PATH/tsearch_data/ukrainian.dict
COPY --from=builder  /dict_uk/distr/hunspell/build/hunspell/uk_UA.aff $SHARE_PATH/tsearch_data/ukrainian.affix
COPY --from=builder  /dict_uk/distr/postgresql/ukrainian.stop $SHARE_PATH/tsearch_data/ukrainian.stop

RUN $(cat ./init-script.sql) >> $SHARE_PATH/snowball_create.sql

USER 26
