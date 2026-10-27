-- 1. Criação e seleção do Banco de Dados
CREATE DATABASE IF NOT EXISTS projeto_integrador;
USE projeto_integrador;

-- Limpeza preventiva de tabelas caso já existam (ordem inversa de dependência)
DROP TABLE IF EXISTS emprestimo_vidraria;
DROP TABLE IF EXISTS uso_reagente;
DROP TABLE IF EXISTS experimento;
DROP TABLE IF EXISTS vidraria;
DROP TABLE IF EXISTS lote_reagente;
DROP TABLE IF EXISTS reagente;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS laboratorio;

-- 2. Tabela Laboratorio
CREATE TABLE laboratorio (
    id_laboratorio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    bloco VARCHAR(20) NOT NULL,
    sala VARCHAR(20) NOT NULL,
    responsavel_tecnico VARCHAR(100) NOT NULL
);

-- 3. Tabela Usuario
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    tipo_acesso VARCHAR(30) NOT NULL, -- Ex: Aluno, Pesquisador, Professor, Técnico
    registro_academico VARCHAR(30) NOT NULL UNIQUE
);

-- 4. Tabela Reagente
CREATE TABLE reagente (
    id_reagente INT AUTO_INCREMENT PRIMARY KEY,
    nome_quimico VARCHAR(100) NOT NULL,
    formula_molecular VARCHAR(50) NOT NULL,
    numero_cas VARCHAR(30) NOT NULL UNIQUE,
    grau_pureza VARCHAR(30) NOT NULL
);

-- 5. Tabela Lote_Reagente (Ligada ao Reagente e ao Laboratório)
CREATE TABLE lote_reagente (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    id_reagente INT NOT NULL,
    id_laboratorio INT NOT NULL,
    numero_lote VARCHAR(50) NOT NULL,
    data_fabricacao DATE NOT NULL,
    data_validade DATE NOT NULL,
    quantidade_atual DECIMAL(10,3) NOT NULL DEFAULT 0.000,
    localizacao_armazenamento VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_reagente) REFERENCES reagente(id_reagente) ON DELETE CASCADE,
    FOREIGN KEY (id_laboratorio) REFERENCES laboratorio(id_laboratorio) ON DELETE CASCADE
);

-- 6. Tabela Vidraria (Ligada ao Laboratório)
CREATE TABLE vidraria (
    id_vidraria INT AUTO_INCREMENT PRIMARY KEY,
    id_laboratorio INT NOT NULL,
    tipo_material VARCHAR(50) NOT NULL, -- Ex: Becker, Erlenmeyer, Probeta
    capacidade_ml INT NOT NULL,
    estado_conservacao VARCHAR(30) NOT NULL DEFAULT 'Ótimo',
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_laboratorio) REFERENCES laboratorio(id_laboratorio) ON DELETE CASCADE
);

-- 7. Tabela Experimento (Ligada ao Usuário e ao Laboratório)
CREATE TABLE experimento (
    id_experimento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_laboratorio INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    data_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_fim DATETIME NULL,
    descricao_protocolo TEXT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_laboratorio) REFERENCES laboratorio(id_laboratorio) ON DELETE CASCADE
);

-- 8. Tabela Associativa Uso_Reagente (Entre Experimento e Lote_Reagente)
CREATE TABLE uso_reagente (
    id_uso_reagente INT AUTO_INCREMENT PRIMARY KEY,
    id_experimento INT NOT NULL,
    id_lote INT NOT NULL,
    quantidade_utilizada DECIMAL(10,3) NOT NULL,
    unidade_medida VARCHAR(20) NOT NULL, -- Ex: g, mL, mg
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_experimento) REFERENCES experimento(id_experimento) ON DELETE CASCADE,
    FOREIGN KEY (id_lote) REFERENCES lote_reagente(id_lote) ON DELETE CASCADE
);

-- 9. Tabela Associativa Emprestimo_Vidraria (Entre Experimento e Vidraria)
CREATE TABLE emprestimo_vidraria (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    id_experimento INT NOT NULL,
    id_vidraria INT NOT NULL,
    data_retirada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_devolucao_prevista DATETIME NOT NULL,
    data_devolucao_real DATETIME NULL,
    observacao VARCHAR(255),
    FOREIGN KEY (id_experimento) REFERENCES experimento(id_experimento) ON DELETE CASCADE,
    FOREIGN KEY (id_vidraria) REFERENCES vidraria(id_vidraria) ON DELETE CASCADE
