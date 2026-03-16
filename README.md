# Automated-NTFS-Provisioning

[English](#english) | [Português](#português)

## English

This project originated from a real-world need to automate access provisioning within a corporate IT infrastructure. In environments demanding agility, manual folder creation with multiple permissions is a slow process prone to human error.

This script is particularly useful for legacy systems, having been developed and tested with a focus on Windows Server 2008 R2.
Problems Solved

  > ACL Automation: Replaces manual "Properties > Security" clicks with rapid script execution.

  > Consistency: Ensures folder structure remains identical for every new Job/Client.

  > Simple Access Matrix: Allows permissions to be managed via .txt files, facilitating auditing before deployment.

Technologies

  > PowerShell: Automation logic and file manipulation.

  > icacls: Native Windows tool for advanced Access Control List (ACL) management.

How it Works

  > The script reads a Template folder.

  > It verifies text files containing Active Directory group/user names.

   > It creates the destination structure and applies Read (R) or Modify (M) permissions granularly.

Technical Note: Includes error handling for multi-language systems (PT-BR and EN-US) by validating icacls output messages.

<a name="descrição-português"></a>

## Português

Este projeto nasceu da necessidade real de automatizar o provisionamento de acessos em uma infraestrutura de TI corporativa. Em ambientes que exigem agilidade, a criação manual de pastas com múltiplas permissões é um processo lento e propenso a falhas humanas.

Este script é especialmente útil para sistemas legados, tendo sido desenvolvido e testado com foco em Windows Server 2008 R2.
O que ele resolve?

  > Automação de ACLs: Substitui o clique manual em "Propriedades > Segurança" por uma execução rápida de script.

  > Consistência: Garante que a estrutura de pastas seja sempre a mesma para cada novo Job/Cliente.

  > Matriz de Acesso Simples: Permite que as permissões sejam geridas via arquivos .txt, facilitando a visualização antes do deploy.

Tecnologias Utilizadas

  > PowerShell: Lógica de automação e manipulação de arquivos.

  > icacls: Ferramenta nativa do Windows para gestão avançada de listas de controle de acesso (ACLs).

Como Funciona

  > O script lê uma pasta modelo (Template).

  > Verifica arquivos de texto contendo os nomes de grupos/usuários do Active Directory.

  > Cria a estrutura no destino e aplica permissões de Leitura (R) ou Modificação (M) de forma granular.

Nota Técnica: O script inclui tratamento de erros para sistemas em diferentes idiomas (PT-BR e EN-US), validando as mensagens de saída do icacls.
