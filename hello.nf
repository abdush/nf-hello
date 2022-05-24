#!/usr/bin/env nextflow

// define parameters
params.greeting  = 'Hello world!'

// create channel using factory method
greeting_ch = Channel.from(params.greeting)

// process definitions
process splitLetters {

    input:
    val x from greeting_ch

    output:
    file 'chunk_*' into letters_ch

    """
    printf '$x' | split -b 6 - chunk_
    """
}


process convertToUpper {

    input:
    file y from letters_ch.flatten()

    output:
    stdout into result_ch
    //file "${y}_conv.txt" into result_ch

    """
    #cat $y | tr '[a-z]' '[A-Z]'
    cat $y | tr '[a-z]' '[A-Z]' | rev
    #cat $y | tr '[a-z]' '[A-Z]' | rev > ${y}_conv.txt 
    """
}

result_ch.view{ it }
