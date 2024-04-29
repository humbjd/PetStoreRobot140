*** Settings ***
# Bibliotecas e Configurações
Library    RequestsLibrary


*** Variables ***
# Objetos, Atributos e Variables
${url}    https://petstore.swagger.io/v2/pet

${id}     173218101                     # $ sinaliza uma variavel simples
${name}    Snoopy
&{category}    id=1    name=cachorro    # & = lista com campos determinados. Ex: id e name - seria {}
@{photoUrls}                            # @ sinaliza uma lista com vários registros - seria []
&{tag}    id=1    name=vacinado
@{tags}   ${tag}                        # Fez uma lista de outra lista
${status}    available

*** Test Cases ***
# Descritivo de Negócio + Passos de Automação

Post pet
    # Montar a mensagem / body
    ${body}    Create Dictionary    id=${id}    category=${category}    name=${name}    
    ...                             photoUrls=${photoUrls}  tags=${tags}    status=${status}
    
    # Executar
    ${response}    POST    url=${url}    json=${body}

    # Validar
    ${response_body}    Set Variable    ${response.json()}  # Recebe o conteúdo da outra variável
    Log To Console      ${response_body}    # imprimir o retorno da API no terminal / console

    Status Should Be    200
    Should Be Equal    ${response_body}[id]               ${{int($id)}}
    Should Be Equal    ${response_body}[name]             ${name}
    Should Be Equal    ${response_body}[tags][0][id]      ${{int(${tag}[id])}}
    Should Be Equal    ${response_body}[tags][0][name]    ${tag}[name]   
    Should Be Equal    ${response_body}[status]           ${status}



Get pet
    #Executa
    ${response}    GET    ${{$url + '/' + $id}}

    #Valida
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[name]    ${name}
    Should Be Equal    ${response_body}[category][id]    ${category}[id]
    Should Be Equal    ${response_body}[category][name]    ${category}[name]
