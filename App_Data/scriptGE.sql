CREATE DATABASE GestionEmpleadosDB;
GO

USE GestionEmpleadosDB;
GO

-- Tabla: Departamento
CREATE TABLE Departamento (
    IdDepartamento INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255),

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50)
);
GO

-- Tabla: Puesto
CREATE TABLE Puesto (
    IdPuesto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255),
    SalarioBase DECIMAL(10,2),
    IdDepartamento INT NOT NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    FOREIGN KEY (IdDepartamento) REFERENCES Departamento(IdDepartamento)
);
GO

-- Tabla: Usuario
CREATE TABLE Usuario (
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL,
    ContraseñaHash VARCHAR(255) NOT NULL,
    Rol VARCHAR(50) NOT NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50)
);
GO

-- Tabla: Empleado
CREATE TABLE Empleado (
    IdEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    FechaNacimiento DATE,
    Telefono VARCHAR(20),
    Correo VARCHAR(100),
    Direccion VARCHAR(255),
    FechaIngreso DATE,
    Salario DECIMAL(10,2),
    IdDepartamento INT NOT NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    FOREIGN KEY (IdDepartamento) REFERENCES Departamento(IdDepartamento)
);
GO

-- Tabla: Vacaciones
CREATE TABLE Vacaciones (
    IdVacacion INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    CantidadDias INT NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Pendiente',

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);
GO

-- Tabla: Salarios
CREATE TABLE Salarios (
    IdSalario INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    FechaAsignacion DATE NOT NULL,
    Descripcion VARCHAR(255),

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);
GO

-- Tabla: Asistencia
CREATE TABLE Asistencia (
    IdAsistencia INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NOT NULL,
    Fecha DATE NOT NULL,
    HoraEntrada DATETIME NULL,
    HoraSalida DATETIME NULL,
    Observacion VARCHAR(255) NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    CONSTRAINT FK_Asistencia_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
    CONSTRAINT CK_Asistencia_RangoHoras CHECK (HoraSalida IS NULL OR HoraEntrada IS NULL OR HoraSalida >= HoraEntrada)
);
GO


-- Tabla: EvaluacionDesempeño
CREATE TABLE EvaluacionDesempeno (
    IdEvaluacion INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NOT NULL,
    PeriodoInicio DATE NOT NULL,
    PeriodoFin DATE NOT NULL,
    Calificacion DECIMAL(4,2) NOT NULL,
    Comentarios VARCHAR(500) NULL,
    IdEvaluador INT NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    CONSTRAINT FK_Eval_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
    CONSTRAINT FK_Eval_Usuario FOREIGN KEY (IdEvaluador) REFERENCES Usuario(IdUsuario),
    CONSTRAINT CK_Eval_Fechas CHECK (PeriodoFin >= PeriodoInicio),
    CONSTRAINT CK_Eval_Calificacion CHECK (Calificacion BETWEEN 0 AND 10)
);
GO


-- Tabla: Beneficio
CREATE TABLE Beneficio (
    IdBeneficio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    Tipo VARCHAR(50) NULL,
    MontoMensual DECIMAL(10,2) NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50)
);
GO


-- Tabla: EmpleadoBeneficio
CREATE TABLE EmpleadoBeneficio (
    IdEmpleadoBeneficio INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NOT NULL,
    IdBeneficio INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
    Observacion VARCHAR(255) NULL,

    Fecha_Adicion DATETIME DEFAULT GETDATE(),
    Adicionado_Por VARCHAR(50),
    Fecha_Modificacion DATETIME NULL,
    Modificado_Por VARCHAR(50),

    CONSTRAINT FK_EmpBenef_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
    CONSTRAINT FK_EmpBenef_Beneficio FOREIGN KEY (IdBeneficio) REFERENCES Beneficio(IdBeneficio),
    CONSTRAINT CK_EmpBenef_Fechas CHECK (FechaFin IS NULL OR FechaFin >= FechaInicio),
    CONSTRAINT CK_EmpBenef_Estado CHECK (Estado IN ('Activo','Inactivo','Suspendido'))
);
GO

/* =========================
   DEPARTAMENTO
   ========================= */
CREATE PROCEDURE dbo.Departamento_Insert
  @Nombre VARCHAR(100),
  @Descripcion VARCHAR(255)=NULL,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Departamento (Nombre,Descripcion,Fecha_Adicion,Adicionado_Por)
  VALUES (@Nombre,@Descripcion,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdDepartamento;
END
GO

CREATE PROCEDURE dbo.Departamento_Update
  @IdDepartamento INT,
  @Nombre VARCHAR(100),
  @Descripcion VARCHAR(255)=NULL,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Departamento
    SET Nombre=@Nombre, Descripcion=@Descripcion,
        Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdDepartamento=@IdDepartamento;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Departamento_Delete
  @IdDepartamento INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Departamento WHERE IdDepartamento=@IdDepartamento;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Departamento_GetById
  @IdDepartamento INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Departamento WHERE IdDepartamento=@IdDepartamento;
END
GO

CREATE PROCEDURE dbo.Departamento_List
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Departamento
    WHERE (@Buscar IS NULL OR Nombre LIKE '%'+@Buscar+'%')
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY IdDepartamento DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   PUESTO
   ========================= */
CREATE PROCEDURE dbo.Puesto_Insert
  @Nombre VARCHAR(100),
  @Descripcion VARCHAR(255)=NULL,
  @SalarioBase DECIMAL(10,2)=NULL,
  @IdDepartamento INT,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Puesto (Nombre,Descripcion,SalarioBase,IdDepartamento,Fecha_Adicion,Adicionado_Por)
  VALUES (@Nombre,@Descripcion,@SalarioBase,@IdDepartamento,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdPuesto;
END
GO

CREATE PROCEDURE dbo.Puesto_Update
  @IdPuesto INT,
  @Nombre VARCHAR(100),
  @Descripcion VARCHAR(255)=NULL,
  @SalarioBase DECIMAL(10,2)=NULL,
  @IdDepartamento INT,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Puesto
    SET Nombre=@Nombre, Descripcion=@Descripcion, SalarioBase=@SalarioBase,
        IdDepartamento=@IdDepartamento, Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdPuesto=@IdPuesto;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Puesto_Delete
  @IdPuesto INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Puesto WHERE IdPuesto=@IdPuesto;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Puesto_GetById
  @IdPuesto INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Puesto WHERE IdPuesto=@IdPuesto;
END
GO

CREATE PROCEDURE dbo.Puesto_List
  @IdDepartamento INT=NULL,
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Puesto
    WHERE (@IdDepartamento IS NULL OR IdDepartamento=@IdDepartamento)
      AND (@Buscar IS NULL OR Nombre LIKE '%'+@Buscar+'%')
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY IdPuesto DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   USUARIO  (helpers para login)
   ========================= */
CREATE PROCEDURE dbo.Usuario_Insert
  @NombreUsuario VARCHAR(50),
  @ContrasenaHash VARCHAR(255),
  @Rol VARCHAR(50),
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Usuario (NombreUsuario,ContraseñaHash,Rol,Fecha_Adicion,Adicionado_Por)
  VALUES (@NombreUsuario,@ContrasenaHash,@Rol,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdUsuario;
END
GO

CREATE PROCEDURE dbo.Usuario_Update
  @IdUsuario INT,
  @NombreUsuario VARCHAR(50),
  @ContrasenaHash VARCHAR(255),
  @Rol VARCHAR(50),
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Usuario
    SET NombreUsuario=@NombreUsuario, ContraseñaHash=@ContrasenaHash, Rol=@Rol,
        Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdUsuario=@IdUsuario;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Usuario_Delete
  @IdUsuario INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Usuario WHERE IdUsuario=@IdUsuario;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Usuario_GetById
  @IdUsuario INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Usuario WHERE IdUsuario=@IdUsuario;
END
GO

CREATE PROCEDURE dbo.Usuario_List
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Usuario
    WHERE (@Buscar IS NULL OR NombreUsuario LIKE '%'+@Buscar+'%' OR Rol LIKE '%'+@Buscar+'%')
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY IdUsuario DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- Para login: obtener hash/rol por usuario
CREATE PROCEDURE dbo.Usuario_GetByNombreUsuario
  @NombreUsuario VARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT TOP 1 * FROM Usuario WHERE NombreUsuario=@NombreUsuario;
END
GO


/* =========================
   EMPLEADO
   ========================= */
CREATE PROCEDURE dbo.Empleado_Insert
  @Nombre VARCHAR(100),
  @Apellido VARCHAR(100),
  @FechaNacimiento DATE=NULL,
  @Telefono VARCHAR(20)=NULL,
  @Correo VARCHAR(100)=NULL,
  @Direccion VARCHAR(255)=NULL,
  @FechaIngreso DATE=NULL,
  @Salario DECIMAL(10,2)=NULL,
  @IdDepartamento INT,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Empleado
  (Nombre,Apellido,FechaNacimiento,Telefono,Correo,Direccion,FechaIngreso,Salario,IdDepartamento,Fecha_Adicion,Adicionado_Por)
  VALUES (@Nombre,@Apellido,@FechaNacimiento,@Telefono,@Correo,@Direccion,@FechaIngreso,@Salario,@IdDepartamento,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdEmpleado;
END
GO

CREATE PROCEDURE dbo.Empleado_Update
  @IdEmpleado INT,
  @Nombre VARCHAR(100),
  @Apellido VARCHAR(100),
  @FechaNacimiento DATE=NULL,
  @Telefono VARCHAR(20)=NULL,
  @Correo VARCHAR(100)=NULL,
  @Direccion VARCHAR(255)=NULL,
  @FechaIngreso DATE=NULL,
  @Salario DECIMAL(10,2)=NULL,
  @IdDepartamento INT,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Empleado
    SET Nombre=@Nombre, Apellido=@Apellido, FechaNacimiento=@FechaNacimiento, Telefono=@Telefono,
        Correo=@Correo, Direccion=@Direccion, FechaIngreso=@FechaIngreso, Salario=@Salario,
        IdDepartamento=@IdDepartamento, Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdEmpleado=@IdEmpleado;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Empleado_Delete
  @IdEmpleado INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Empleado WHERE IdEmpleado=@IdEmpleado;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Empleado_GetById
  @IdEmpleado INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Empleado WHERE IdEmpleado=@IdEmpleado;
END
GO

CREATE PROCEDURE dbo.Empleado_List
  @IdDepartamento INT=NULL,
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Empleado
    WHERE (@IdDepartamento IS NULL OR IdDepartamento=@IdDepartamento)
      AND (@Buscar IS NULL OR (Nombre+' '+Apellido) LIKE '%'+@Buscar+'%' OR Correo LIKE '%'+@Buscar+'%')
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY IdEmpleado DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   VACACIONES
   ========================= */
CREATE PROCEDURE dbo.Vacaciones_Insert
  @IdEmpleado INT,
  @FechaInicio DATE,
  @FechaFin DATE,
  @CantidadDias INT,
  @Estado VARCHAR(20)='Pendiente',
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@FechaFin < @FechaInicio) BEGIN RAISERROR('FechaFin < FechaInicio',16,1); RETURN; END;
  INSERT INTO Vacaciones (IdEmpleado,FechaInicio,FechaFin,CantidadDias,Estado,Fecha_Adicion,Adicionado_Por)
  VALUES (@IdEmpleado,@FechaInicio,@FechaFin,@CantidadDias,@Estado,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdVacacion;
END
GO

CREATE PROCEDURE dbo.Vacaciones_Update
  @IdVacacion INT,
  @IdEmpleado INT,
  @FechaInicio DATE,
  @FechaFin DATE,
  @CantidadDias INT,
  @Estado VARCHAR(20),
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@FechaFin < @FechaInicio) BEGIN RAISERROR('FechaFin < FechaInicio',16,1); RETURN; END;
  UPDATE Vacaciones
    SET IdEmpleado=@IdEmpleado, FechaInicio=@FechaInicio, FechaFin=@FechaFin,
        CantidadDias=@CantidadDias, Estado=@Estado,
        Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdVacacion=@IdVacacion;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Vacaciones_Delete
  @IdVacacion INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Vacaciones WHERE IdVacacion=@IdVacacion;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Vacaciones_GetById
  @IdVacacion INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Vacaciones WHERE IdVacacion=@IdVacacion;
END
GO

CREATE PROCEDURE dbo.Vacaciones_List
  @IdEmpleado INT=NULL,
  @Estado VARCHAR(20)=NULL,
  @Desde DATE=NULL, @Hasta DATE=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Vacaciones
    WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
      AND (@Estado IS NULL OR Estado=@Estado)
      AND (@Desde IS NULL OR FechaInicio>=@Desde)
      AND (@Hasta IS NULL OR FechaFin<=@Hasta)
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY FechaInicio DESC, IdVacacion DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   SALARIOS
   ========================= */
CREATE PROCEDURE dbo.Salarios_Insert
  @IdEmpleado INT,
  @Monto DECIMAL(10,2),
  @FechaAsignacion DATE,
  @Descripcion VARCHAR(255)=NULL,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@Monto <= 0) BEGIN RAISERROR('Monto <= 0',16,1); RETURN; END;
  INSERT INTO Salarios (IdEmpleado,Monto,FechaAsignacion,Descripcion,Fecha_Adicion,Adicionado_Por)
  VALUES (@IdEmpleado,@Monto,@FechaAsignacion,@Descripcion,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdSalario;
END
GO

CREATE PROCEDURE dbo.Salarios_Update
  @IdSalario INT,
  @IdEmpleado INT,
  @Monto DECIMAL(10,2),
  @FechaAsignacion DATE,
  @Descripcion VARCHAR(255)=NULL,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@Monto <= 0) BEGIN RAISERROR('Monto <= 0',16,1); RETURN; END;
  UPDATE Salarios
    SET IdEmpleado=@IdEmpleado, Monto=@Monto, FechaAsignacion=@FechaAsignacion, Descripcion=@Descripcion,
        Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdSalario=@IdSalario;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Salarios_Delete
  @IdSalario INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Salarios WHERE IdSalario=@IdSalario;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Salarios_GetById
  @IdSalario INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Salarios WHERE IdSalario=@IdSalario;
END
GO

CREATE PROCEDURE dbo.Salarios_List
  @IdEmpleado INT=NULL,
  @Desde DATE=NULL, @Hasta DATE=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Salarios
    WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
      AND (@Desde IS NULL OR FechaAsignacion>=@Desde)
      AND (@Hasta IS NULL OR FechaAsignacion<=@Hasta)
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY FechaAsignacion DESC, IdSalario DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   ASISTENCIA
   ========================= */
CREATE PROCEDURE dbo.Asistencia_Insert
  @IdEmpleado INT,
  @Fecha DATE,
  @HoraEntrada DATETIME=NULL,
  @HoraSalida DATETIME=NULL,
  @Observacion VARCHAR(255)=NULL,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@HoraEntrada IS NOT NULL AND @HoraSalida IS NOT NULL AND @HoraSalida < @HoraEntrada)
     BEGIN RAISERROR('HoraSalida < HoraEntrada',16,1); RETURN; END;
  INSERT INTO Asistencia (IdEmpleado,Fecha,HoraEntrada,HoraSalida,Observacion,Fecha_Adicion,Adicionado_Por)
  VALUES (@IdEmpleado,@Fecha,@HoraEntrada,@HoraSalida,@Observacion,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdAsistencia;
END
GO

CREATE PROCEDURE dbo.Asistencia_Update
  @IdAsistencia INT,
  @IdEmpleado INT,
  @Fecha DATE,
  @HoraEntrada DATETIME=NULL,
  @HoraSalida DATETIME=NULL,
  @Observacion VARCHAR(255)=NULL,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@HoraEntrada IS NOT NULL AND @HoraSalida IS NOT NULL AND @HoraSalida < @HoraEntrada)
     BEGIN RAISERROR('HoraSalida < HoraEntrada',16,1); RETURN; END;
  UPDATE Asistencia
    SET IdEmpleado=@IdEmpleado, Fecha=@Fecha, HoraEntrada=@HoraEntrada, HoraSalida=@HoraSalida,
        Observacion=@Observacion, Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdAsistencia=@IdAsistencia;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Asistencia_Delete
  @IdAsistencia INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Asistencia WHERE IdAsistencia=@IdAsistencia;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Asistencia_GetById
  @IdAsistencia INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Asistencia WHERE IdAsistencia=@IdAsistencia;
END
GO

CREATE PROCEDURE dbo.Asistencia_List
  @IdEmpleado INT=NULL,
  @Desde DATE=NULL, @Hasta DATE=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Asistencia
    WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
      AND (@Desde IS NULL OR Fecha>=@Desde)
      AND (@Hasta IS NULL OR Fecha<=@Hasta)
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY Fecha DESC, IdAsistencia DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   EVALUACION DESEMPEÑO
   ========================= */
CREATE PROCEDURE dbo.EvaluacionDesempeno_Insert
  @IdEmpleado INT,
  @PeriodoInicio DATE,
  @PeriodoFin DATE,
  @Calificacion DECIMAL(4,2),
  @Comentarios VARCHAR(500)=NULL,
  @IdEvaluador INT=NULL,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@PeriodoFin < @PeriodoInicio) BEGIN RAISERROR('PeriodoFin < PeriodoInicio',16,1); RETURN; END;
  IF (@Calificacion < 0 OR @Calificacion > 10) BEGIN RAISERROR('Calificacion fuera de rango',16,1); RETURN; END;
  INSERT INTO EvaluacionDesempeno
  (IdEmpleado,PeriodoInicio,PeriodoFin,Calificacion,Comentarios,IdEvaluador,Fecha_Adicion,Adicionado_Por)
  VALUES (@IdEmpleado,@PeriodoInicio,@PeriodoFin,@Calificacion,@Comentarios,@IdEvaluador,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdEvaluacion;
END
GO

CREATE PROCEDURE dbo.EvaluacionDesempeno_Update
  @IdEvaluacion INT,
  @IdEmpleado INT,
  @PeriodoInicio DATE,
  @PeriodoFin DATE,
  @Calificacion DECIMAL(4,2),
  @Comentarios VARCHAR(500)=NULL,
  @IdEvaluador INT=NULL,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@PeriodoFin < @PeriodoInicio) BEGIN RAISERROR('PeriodoFin < PeriodoInicio',16,1); RETURN; END;
  IF (@Calificacion < 0 OR @Calificacion > 10) BEGIN RAISERROR('Calificacion fuera de rango',16,1); RETURN; END;
  UPDATE EvaluacionDesempeno
    SET IdEmpleado=@IdEmpleado, PeriodoInicio=@PeriodoInicio, PeriodoFin=@PeriodoFin,
        Calificacion=@Calificacion, Comentarios=@Comentarios, IdEvaluador=@IdEvaluador,
        Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdEvaluacion=@IdEvaluacion;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.EvaluacionDesempeno_Delete
  @IdEvaluacion INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM EvaluacionDesempeno WHERE IdEvaluacion=@IdEvaluacion;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.EvaluacionDesempeno_GetById
  @IdEvaluacion INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM EvaluacionDesempeno WHERE IdEvaluacion=@IdEvaluacion;
END
GO

CREATE PROCEDURE dbo.EvaluacionDesempeno_List
  @IdEmpleado INT=NULL,
  @Desde DATE=NULL, @Hasta DATE=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM EvaluacionDesempeno
    WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
      AND (@Desde IS NULL OR PeriodoInicio>=@Desde)
      AND (@Hasta IS NULL OR PeriodoFin<=@Hasta)
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY PeriodoFin DESC, IdEvaluacion DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   BENEFICIO
   ========================= */
CREATE PROCEDURE dbo.Beneficio_Insert
  @Nombre VARCHAR(100),
  @Descripcion VARCHAR(255)=NULL,
  @Tipo VARCHAR(50)=NULL,
  @MontoMensual DECIMAL(10,2)=NULL,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Beneficio (Nombre,Descripcion,Tipo,MontoMensual,Fecha_Adicion,Adicionado_Por)
  VALUES (@Nombre,@Descripcion,@Tipo,@MontoMensual,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdBeneficio;
END
GO

CREATE PROCEDURE dbo.Beneficio_Update
  @IdBeneficio INT,
  @Nombre VARCHAR(100),
  @Descripcion VARCHAR(255)=NULL,
  @Tipo VARCHAR(50)=NULL,
  @MontoMensual DECIMAL(10,2)=NULL,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Beneficio
    SET Nombre=@Nombre, Descripcion=@Descripcion, Tipo=@Tipo, MontoMensual=@MontoMensual,
        Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdBeneficio=@IdBeneficio;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Beneficio_Delete
  @IdBeneficio INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Beneficio WHERE IdBeneficio=@IdBeneficio;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.Beneficio_GetById
  @IdBeneficio INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM Beneficio WHERE IdBeneficio=@IdBeneficio;
END
GO

CREATE PROCEDURE dbo.Beneficio_List
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM Beneficio
    WHERE (@Buscar IS NULL OR Nombre LIKE '%'+@Buscar+'%' OR Tipo LIKE '%'+@Buscar+'%')
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY Nombre ASC, IdBeneficio DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO


/* =========================
   EMPLEADO-BENEFICIO
   ========================= */
CREATE PROCEDURE dbo.EmpleadoBeneficio_Insert
  @IdEmpleado INT,
  @IdBeneficio INT,
  @FechaInicio DATE,
  @FechaFin DATE=NULL,
  @Estado VARCHAR(20)='Activo',
  @Observacion VARCHAR(255)=NULL,
  @Adicionado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@FechaFin IS NOT NULL AND @FechaFin < @FechaInicio) BEGIN RAISERROR('FechaFin < FechaInicio',16,1); RETURN; END;
  IF (@Estado NOT IN ('Activo','Inactivo','Suspendido')) BEGIN RAISERROR('Estado inválido',16,1); RETURN; END;
  INSERT INTO EmpleadoBeneficio
  (IdEmpleado,IdBeneficio,FechaInicio,FechaFin,Estado,Observacion,Fecha_Adicion,Adicionado_Por)
  VALUES (@IdEmpleado,@IdBeneficio,@FechaInicio,@FechaFin,@Estado,@Observacion,GETDATE(),@Adicionado_Por);
  SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdEmpleadoBeneficio;
END
GO

CREATE PROCEDURE dbo.EmpleadoBeneficio_Update
  @IdEmpleadoBeneficio INT,
  @IdEmpleado INT,
  @IdBeneficio INT,
  @FechaInicio DATE,
  @FechaFin DATE=NULL,
  @Estado VARCHAR(20),
  @Observacion VARCHAR(255)=NULL,
  @Modificado_Por VARCHAR(50)=NULL
AS
BEGIN
  SET NOCOUNT ON;
  IF (@FechaFin IS NOT NULL AND @FechaFin < @FechaInicio) BEGIN RAISERROR('FechaFin < FechaInicio',16,1); RETURN; END;
  IF (@Estado NOT IN ('Activo','Inactivo','Suspendido')) BEGIN RAISERROR('Estado inválido',16,1); RETURN; END;
  UPDATE EmpleadoBeneficio
    SET IdEmpleado=@IdEmpleado, IdBeneficio=@IdBeneficio, FechaInicio=@FechaInicio, FechaFin=@FechaFin,
        Estado=@Estado, Observacion=@Observacion, Fecha_Modificacion=GETDATE(), Modificado_Por=@Modificado_Por
  WHERE IdEmpleadoBeneficio=@IdEmpleadoBeneficio;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.EmpleadoBeneficio_Delete
  @IdEmpleadoBeneficio INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM EmpleadoBeneficio WHERE IdEmpleadoBeneficio=@IdEmpleadoBeneficio;
  SELECT @@ROWCOUNT AS Afectados;
END
GO

CREATE PROCEDURE dbo.EmpleadoBeneficio_GetById
  @IdEmpleadoBeneficio INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM EmpleadoBeneficio WHERE IdEmpleadoBeneficio=@IdEmpleadoBeneficio;
END
GO

CREATE PROCEDURE dbo.EmpleadoBeneficio_List
  @IdEmpleado INT=NULL,
  @IdBeneficio INT=NULL,
  @Estado VARCHAR(20)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH F AS (
    SELECT * FROM EmpleadoBeneficio
    WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
      AND (@IdBeneficio IS NULL OR IdBeneficio=@IdBeneficio)
      AND (@Estado IS NULL OR Estado=@Estado)
  )
  SELECT COUNT(*) AS Total FROM F;
  SELECT * FROM F
  ORDER BY FechaInicio DESC, IdEmpleadoBeneficio DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Departamento_List
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Departamento
  WHERE (@Buscar IS NULL OR Nombre LIKE '%'+@Buscar+'%');

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdDepartamento DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Puesto_List
  @IdDepartamento INT=NULL,
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Puesto
  WHERE (@IdDepartamento IS NULL OR IdDepartamento=@IdDepartamento)
    AND (@Buscar IS NULL OR Nombre LIKE '%'+@Buscar+'%');

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdPuesto DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Usuario_List
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Usuario
  WHERE (@Buscar IS NULL OR NombreUsuario LIKE '%'+@Buscar+'%');

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdUsuario DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Empleado_List
  @IdDepartamento INT=NULL,
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Empleado
  WHERE (@IdDepartamento IS NULL OR IdDepartamento=@IdDepartamento)
    AND (
         @Buscar IS NULL
         OR (Nombre+' '+Apellido) LIKE '%'+@Buscar+'%'
         OR Correo LIKE '%'+@Buscar+'%'
        );

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdEmpleado DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Vacaciones_List
  @IdEmpleado INT=NULL,
  @Estado VARCHAR(20)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Vacaciones
  WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
    AND (@Estado IS NULL OR Estado=@Estado);

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdVacacion DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Salarios_List
  @IdEmpleado INT=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Salarios
  WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado);

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdSalario DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Asistencia_List
  @IdEmpleado INT=NULL,
  @Fecha DATE=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Asistencia
  WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
    AND (@Fecha IS NULL OR Fecha=@Fecha);

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdAsistencia DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.EvaluacionDesempeno_List
  @IdEmpleado INT=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM EvaluacionDesempeno
  WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado);

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdEvaluacion DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.Beneficio_List
  @Buscar VARCHAR(100)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM Beneficio
  WHERE (@Buscar IS NULL OR Nombre LIKE '%'+@Buscar+'%');

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdBeneficio DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

ALTER PROCEDURE dbo.EmpleadoBeneficio_List
  @IdEmpleado INT=NULL,
  @IdBeneficio INT=NULL,
  @Estado VARCHAR(20)=NULL,
  @Page INT=1, @PageSize INT=20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT *
  INTO #F
  FROM EmpleadoBeneficio
  WHERE (@IdEmpleado IS NULL OR IdEmpleado=@IdEmpleado)
    AND (@IdBeneficio IS NULL OR IdBeneficio=@IdBeneficio)
    AND (@Estado IS NULL OR Estado=@Estado);

  SELECT COUNT(*) AS Total FROM #F;

  SELECT *
  FROM #F
  ORDER BY IdEmpleadoBeneficio DESC
  OFFSET (@Page-1)*@PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- Departamentos base
INSERT INTO Departamento (Nombre, Descripcion) VALUES
('TI', 'Tecnología'),
('RRHH', 'Recursos Humanos');

-- Empleados base (usa IdDepartamento existentes)
INSERT INTO Empleado (Nombre, Apellido, FechaNacimiento, Telefono, Correo, Direccion, FechaIngreso, Salario, IdDepartamento, Adicionado_Por)
VALUES
('Ana', 'Gómez', '1990-05-10', '8888-8888', 'ana@example.com', 'Calle 123', '2024-01-15', 850.50, 1, 'seed'),
('Luis', 'Pérez', '1988-03-22', '7777-7777', 'luis@example.com', 'Av. 456', '2023-11-01', 920.00, 2, 'seed');
