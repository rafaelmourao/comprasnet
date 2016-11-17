# comprasnet

The COMPRASNET database comprises information about all public procurement processes from the Brazilian federal government since 2001. In particular, in the [COMPRASNET website] (https://www.comprasgovernamentais.gov.br/) entities of the federal government are able to run a form of online procurement auction called "pregao". Since 2005 almost all purchases above R$8.000 (roughly US$2.500), with the exception of engineering projects and some other classes of products and services, need to be done through this online procedure.

This is a collection of R and Perl scripts used to clean the data from a database dump with data until March 2015, filter it and run a few regressions to predict departures from the expected prices. Tests to pinpoint industries and locations where collusion is likely are included in the "tests" folder. I've left out tests for specific classes of products and groups of firms. 

Feel free to contact me if you want more information or access to the data.
