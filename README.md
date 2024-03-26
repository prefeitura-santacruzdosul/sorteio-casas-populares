# sorteio-casas-populares
Software criado para realizar o sorteio das casas populares dos loteamentos Santa Maria e Mãe de Deus, em 2021.


![image](https://github.com/prefeitura-santacruzdosul/sorteio-casas-populares/assets/162624904/44595d5f-d95d-4130-9dcc-334ca48bd5bc)


# Tecnologia

Lazarus / Free Pascal RAD IDE (https://www.lazarus-ide.org/)

Não qual a versão do Lazarus foi usada na época para criar e compilar, mas o programa foi utilizado em 2 sorteios transmitidos ao vivo e publicados no Facebook:

## Loteamento Santa Maria
10 de abril de 2021

https://www.facebook.com/prefeiturasantacruzdosul/videos/sorteio-dos-benefici%C3%A1rios-para-loteamento-santa-maria/738829640159130/

## Loteamento Mãe de Deus
01 de julho de 2021

https://www.facebook.com/prefeiturasantacruzdosul/videos/sorteio-casas-populares-loteamento-m%C3%A3e-de-deus/323073022633939/



# Passos
- clicar no Botão 1 para carregar um arquivo contendo a lista das Pessoas contempladas.
- clicar no Botão 2 para carregar um arquivo contendo a lista das Casas.
- clicar no Botão 3 para realizar o sorteio.
- clicar no Botão 4 para salvar um arquivo com o resultado do sorteio.

# Sorteio
- Ao clicar no Botão 3, é ativado um componente contador de tempo (Timer).
- A cada 1 segundo é selecionada uma pessoa aleatória da lista de Pessoas, usando a função "Random".
- Esta pessoa então é inserida na primeira casa da lista que ainda não tem uma pessoa relacionada.
- Depois dessa pessoa ser relacionada a uma casa, ela é excluída da lista de Pessoas.

# Resultados

Os resultados dos sorteios estão disponíveis para consulta nesta página:
- https://www.santacruz.rs.gov.br/conteudo/sorteios-habitacionais

