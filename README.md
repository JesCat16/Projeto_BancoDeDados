# Projeto_BancoDeDados
## Jéssica Martins de Jesus / RA: 22.124.096-3
Projeto final da matéria Banco de Dados.
---
title: Order example
---
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
