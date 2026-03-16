<#
.SYNOPSIS
    Automated NTFS Folder Structure and Permission Provisioning.
.DESCRIPTION
    Creates a standardized folder hierarchy and applies security groups/users 
    from .txt files using icacls. Supports PT-BR and EN-US system messages.
.AUTHOR
    Raphael Lopes (PH)
#>

# --- 1. CONFIGURAÇÕES GERAIS ---
$DomainName     = "SEUDOMINIO" # Altere para o nome do seu domínio (ex: CONTOSO)
$SourceDir      = "C:\Automacao\Origem"
$TemplateFolder = "$SourceDir\MODELO_PADRAO"
$TargetRoot     = "C:\Automacao\Destino"

# --- 2. SISTEMA DE LOGS ---
$LogPath = "C:\Automacao\Logs"
if (!(Test-Path $LogPath)) { New-Item $LogPath -ItemType Directory }

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$LogFile   = "$LogPath\Provisioning_$Timestamp.txt"

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $Time = Get-Date -Format "HH:mm:ss"
    $Line = "[$Time] $Message"
    Write-Host $Message -ForegroundColor $Color
    $Line | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

# --- 3. MAPEAMENTO DE PASTAS VS PREFIXOS TXT ---
# Formato: "Nome da Pasta no Destino" = "Prefixo do Arquivo TXT"
$FolderMapping = @{
    "01_Compras"    = "Compras"
    "02_Financeiro" = "Finan"
    "03_Projetos"   = "Proj"
    "04_Publico"    = "Pub"
}

Write-Log "--- INÍCIO DO PROCESSO ---" -Color Cyan

# Entrada de dados
$ClientName = Read-Host "Nome do Cliente/Projeto"
$JobID      = Read-Host "ID do Job/Processo"
$FinalPath  = Join-Path $TargetRoot "$ClientName\Job-$JobID"

try {
    # 4. CRIAÇÃO DA ESTRUTURA
    if (-not (Test-Path $FinalPath)) {
        Write-Log "[INFO] Criando estrutura em: $FinalPath" -Color Yellow
        New-Item -Path $FinalPath -ItemType Directory -Force | Out-Null
        Copy-Item -Path "$TemplateFolder\*" -Destination $FinalPath -Recurse -Force
    }

    # 5. LOOP DE PERMISSÕES
    foreach ($Entry in $FolderMapping.GetEnumerator()) {
        $SubFolder = Join-Path $FinalPath $Entry.Key
        $Prefix    = $Entry.Value

        if (Test-Path $SubFolder) {
            Write-Log "Processando: $($Entry.Key)" -Color Green
            
            # Procura por arquivos "Nome R.txt" (Read) e "Nome W.txt" (Write/Modify)
            foreach ($Suffix in @(" R", " W")) {
                $TxtFile = "$SourceDir\$($Prefix)$($Suffix).txt"

                if (Test-Path $TxtFile) {
                    $Users = (Get-Content $TxtFile) -split ';'
                    $Mode  = if ($Suffix -eq " R") { "R" } else { "M" }

                    foreach ($User in $Users) {
                        $CleanUser = $User.Trim()
                        if (-not [string]::IsNullOrEmpty($CleanUser)) {
                            Write-Log "   > Aplicando $Mode para: $DomainName\$CleanUser" -Color Gray
                            
                            # Execução do icacls com tratamento multilingue
                            $Result = icacls "$SubFolder" /grant "$DomainName\${CleanUser}:(OI)(CI)$Mode" /T /C 2>&1
                            
                            if ($Result -match "Successfully processed" -or $Result -match "Processados com sucesso") {
                                Write-Log "     [OK] Sucesso." -Color Green
                            } else {
                                Write-Log "     [!] Falha: $Result" -Color Red
                            }
                        }
                    }
                }
            }
        }
    }
} catch {
    Write-Log "[ERRO CRÍTICO]: $($_.Exception.Message)" -Color White -BackgroundColor Red
}

Write-Log "--- FIM DO PROCESSO ---" -Color Cyan