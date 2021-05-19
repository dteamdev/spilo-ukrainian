/*
 * text search configuration for ukrainan language
 *
 * Copyright (c) 2021, :DTeam (dteam.dev)
 *
 * src/backend/snowball/snowball.sql.in
 *
 * ukrainan and certain other macros are replaced for each language;
 *
 * Note: this file is read in single-user -j mode, which means that the
 * command terminator is semicolon-newline-newline; whenever the backend
 * sees that, it stops and executes what it's got.  If you write a lot of
 * statements without empty lines between, they'll all get quoted to you
 * in any error message about one of them, so don't do that.  Also, you
 * cannot write a semicolon immediately followed by an empty line in a
 * string literal (including a function body!) or a multiline comment.
 */

CREATE
    TEXT SEARCH DICTIONARY ukrainian_ispell
    ( TEMPLATE = ispell, DictFile = ukrainian, AffFile = ukrainian, StopWords = ukrainian );

COMMENT
    ON TEXT SEARCH DICTIONARY ukrainian_ispell IS 'ispell dict for ukrainian language';

CREATE
    TEXT SEARCH DICTIONARY ukrainian_stem
    ( TEMPLATE = simple, StopWords = ukrainian );

COMMENT
    ON TEXT SEARCH DICTIONARY ukrainian_stem IS 'simple stemmer for ukrainian language';

CREATE
    TEXT SEARCH DICTIONARY ukrainian_dict
    ( TEMPLATE = synonym, SYNONYMS = ukrainian );

CREATE
    TEXT SEARCH CONFIGURATION ukrainian (PARSER =default);

ALTER
    TEXT SEARCH CONFIGURATION ukrainian ADD MAPPING
    FOR asciihword, asciiword, word, hword, hword_part
    WITH ukrainian_dict, ukrainian_ispell, ukrainian_stem;

ALTER TEXT SEARCH CONFIGURATION ukrainian ALTER MAPPING 
    FOR int, uint, numhword, numword, hword_numpart, email, 
        float, file, url, url_path, version, host, sfloat 
    WITH simple;

ALTER TEXT SEARCH CONFIGURATION ukrainian ALTER MAPPING 
    FOR asciihword, asciiword, hword_asciipart 
    WITH english_stem;

