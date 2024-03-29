DROP TABLE IF EXISTS Filme;
DROP TABLE IF EXISTS Interpreta;
DROP TABLE IF EXISTS Artista;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Software;
DROP TABLE IF EXISTS AtoDeManutencao;
DROP TABLE IF EXISTS TipoDeManutencao;
DROP TABLE IF EXISTS RequisicaoDeExemplar;
DROP TABLE IF EXISTS Requisicao;
DROP TABLE IF EXISTS Equipamento;
DROP TABLE IF EXISTS Modelo;
DROP TABLE IF EXISTS TipoEquipamento;
DROP TABLE IF EXISTS Exemplar;
DROP TABLE IF EXISTS Autoria;
DROP TABLE IF EXISTS Autor;
DROP TABLE IF EXISTS Livro;
DROP TABLE IF EXISTS Publicacao;
DROP TABLE IF EXISTS ReservaDeSala;
DROP TABLE IF EXISTS Reserva;
DROP TABLE IF EXISTS Sala;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Utilizador;
DROP TABLE IF EXISTS Pessoa;

CREATE TABLE Pessoa(
    cartaoCidadao INTEGER UNIQUE PRIMARY KEY,
    nome TEXT NOT NULL,
    dataNascimento DATE NOT NULL,
    telefone INTEGER NOT NULL
);

CREATE TABLE Utilizador(
    cartaoCidadao INTEGER UNIQUE PRIMARY KEY REFERENCES Pessoa(cartaoCidadao) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Funcionario(
    cartaoCidadao INTEGER UNIQUE PRIMARY KEY REFERENCES Pessoa(cartaoCidadao) ON DELETE CASCADE ON UPDATE CASCADE,
    salario FLOAT,
    contribuinte INTEGER NOT NULL UNIQUE,
    morada TEXT NOT NULL,
    horaEntrada TIME NOT NULL,
    horaSaida TIME NOT NULL
);

CREATE TABLE Reserva(
    idReserva INTEGER PRIMARY KEY AUTOINCREMENT,
    motivo TEXT,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    duracao INTEGER NOT NULL,
    ccUtilizador INTEGER REFERENCES Utilizador(cartaoCidadao) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sala(
    numero INTEGER UNIQUE PRIMARY KEY,
    tipo TEXT,
    capacidade INTEGER NOT NULL
);

CREATE TABLE ReservaDeSala(
    idReserva INTEGER REFERENCES Reserva(idReserva) ON DELETE CASCADE ON UPDATE CASCADE,
    numeroSala INTEGER REFERENCES Sala(numero) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(idReserva, numeroSala) 
);

CREATE TABLE Equipamento(
    idEquipamento INTEGER PRIMARY KEY AUTOINCREMENT,
    modelo TEXT REFERENCES Modelo(nomeModelo) ON DELETE CASCADE ON UPDATE CASCADE,
    numeroSala INTEGER REFERENCES Sala(numero) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Modelo(
    nomeModelo TEXT PRIMARY KEY NOT NULL,
    marca TEXT NOT NULL,
    nomeTipo TEXT REFERENCES TipoEquipamento(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TipoEquipamento(
    nome TEXT UNIQUE PRIMARY KEY,
    proposito TEXT,
    CONSTRAINT nome_tipo CHECK (
                        nome = 'Leitor de CDs' 
                        OR nome = 'Leitor de DVDs' 
                        OR nome = 'Leitor de VHS'
                        OR nome = 'Computador'
                        OR nome = 'Projetor'
                        OR nome = 'Televisão')
);

CREATE TABLE Requisicao(
    idRequisicao INTEGER PRIMARY KEY AUTOINCREMENT,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    diasAtraso INTEGER,
    multa FLOAT,
    ccUtilizador INTEGER REFERENCES Utilizador(cartaoCidadao) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Exemplar(
    idExemplar INTEGER PRIMARY KEY AUTOINCREMENT,
    possivelRequisitar INTEGER,
    idSala INTEGER REFERENCES Sala(numero) ON DELETE CASCADE ON UPDATE CASCADE,
    idPublicacao INTEGER REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT boolean CHECK (possivelRequisitar = 0 OR possivelRequisitar = 1)
);

CREATE TABLE TipoDeManutencao(
    nome TEXT PRIMARY KEY UNIQUE
);

CREATE TABLE AtoDeManutencao(
    ccFuncionario INTEGER REFERENCES Funcionario(cartaoCidadao) ON DELETE CASCADE ON UPDATE CASCADE,
    nomeManutencao TEXT NOT NULL REFERENCES TipoDeManutencao(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    idExemplar INTEGER NOT NULL REFERENCES Exemplar(idExemplar) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(ccFuncionario, nomeManutencao, idExemplar)
);

CREATE TABLE Publicacao(
    idPublicacao INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    genero TEXT,
    idadeMinima INTEGER,
    quantidade INTEGER DEFAULT 0
);

CREATE TABLE Livro(
    idPublicacao INTEGER PRIMARY KEY NOT NULL REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    editora TEXT NOT NULL, 
    edicao INTEGER CHECK (edicao > 0) NOT NULL
);

CREATE TABLE Autor(
    idAutor INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);


CREATE TABLE Autoria(
    idPublicacao INTEGER NOT NULL REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    idAutor INTEGER NOT NULL REFERENCES Autor(idAutor) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(idPublicacao, idAutor)
);

CREATE TABLE Software(
    idPublicacao INTEGER PRIMARY KEY NOT NULL REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    versao FLOAT NOT NULL CHECK(versao > 0),
    developer TEXT NOT NULL
);

CREATE TABLE Album(
    idPublicacao INTEGER PRIMARY KEY NOT NULL REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    produtor TEXT NOT NULL
);

CREATE TABLE Artista(
    idArtista INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);

CREATE TABLE Interpreta(
    idPublicacao INTEGER NOT NULL REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    idArtista INTEGER NOT NULL REFERENCES Artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(idPublicacao, idArtista)
);

CREATE TABLE Filme(
    idPublicacao INTEGER PRIMARY KEY NOT NULL REFERENCES Publicacao(idPublicacao) ON DELETE CASCADE ON UPDATE CASCADE,
    realizador TEXT NOT NULL,
    estudio TEXT NOT NULL
);

CREATE TABLE RequisicaoDeExemplar(
    idRequisicao INTEGER NOT NULL REFERENCES Requisicao(idRequisicao) ON DELETE CASCADE ON UPDATE CASCADE,
    idExemplar INTEGER NOT NULL REFERENCES Exemplar(idExemplar) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (idRequisicao, idExemplar)
);
