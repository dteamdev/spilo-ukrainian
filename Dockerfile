ARG SPILO_TAG

FROM openjdk:8 as builder

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

RUN git clone https://github.com/brown-uk/dict_uk.git
RUN rm ./dict_uk/distr/hunspell/src/main/groovy/Hunspell.groovy
COPY ./Hunspell.groovy ./dict_uk/distr/hunspell/src/main/groovy

WORKDIR ./dict_uk/distr/hunspell
RUN ../../gradlew hunspell


RUN mv ./build/hunspell/uk_UA.dic ukrainian.dict && \
 mv ./build/hunspell/uk_UA.aff ukrainian.affix && \
 mv /dict_uk/distr/postgresql/ukrainian.stop ukrainian.stop

FROM registry.opensource.zalan.do/acid/spilo-$SPILO_TAG

COPY ./init-script.sql .

RUN cat ./init-script.sql >> /usr/share/postgresql/13/snowball_create.sql
COPY ./tsearch_data/ukrainian.syn /usr/share/postgresql/13/tsearch_data/ukrainian.syn
RUN cat ./init-script.sql >> /usr/share/postgresql/12/snowball_create.sql
COPY ./tsearch_data/ukrainian.syn /usr/share/postgresql/12/tsearch_data/ukrainian.syn
RUN cat ./init-script.sql >> /usr/share/postgresql/11/snowball_create.sql
COPY ./tsearch_data/ukrainian.syn /usr/share/postgresql/11/tsearch_data/ukrainian.syn
RUN cat ./init-script.sql >> /usr/share/postgresql/10/snowball_create.sql
COPY ./tsearch_data/ukrainian.syn /usr/share/postgresql/10/tsearch_data/ukrainian.syn
RUN cat ./init-script.sql >> /usr/share/postgresql/9.6/snowball_create.sql
COPY ./tsearch_data/ukrainian.syn /usr/share/postgresql/9.6/tsearch_data/ukrainian.syn


COPY --from=builder  ukrainian.dict ukrainian.affix ukrainian.stop /usr/share/postgresql/13/tsearch_data/
COPY --from=builder  ukrainian.dict ukrainian.affix ukrainian.stop /usr/share/postgresql/12/tsearch_data/
COPY --from=builder  ukrainian.dict ukrainian.affix ukrainian.stop /usr/share/postgresql/11/tsearch_data/
COPY --from=builder  ukrainian.dict ukrainian.affix ukrainian.stop /usr/share/postgresql/10/tsearch_data/
COPY --from=builder  ukrainian.dict ukrainian.affix ukrainian.stop /usr/share/postgresql/9.6/tsearch_data/
