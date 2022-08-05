CREATE TABLESPACE registros_geograficos 
  DATAFILE 'registros_geograficos.dat'
  SIZE 20M AUTOEXTEND ON;

CREATE TABLESPACE registros_alertas
  DATAFILE 'registros_alertas.dat'
  SIZE 20M AUTOEXTEND ON;

CREATE TABLESPACE registros_alertas2
  DATAFILE 'registros_alertas2.dat'
  SIZE 20M AUTOEXTEND ON;

CREATE TABLESPACE registros_reportes
  DATAFILE 'registros_reportes.dat'
  SIZE 20M AUTOEXTEND ON;

CREATE TABLESPACE registros_medidas
  DATAFILE 'registros_medidas.dat'
  SIZE 20M AUTOEXTEND ON;

CREATE TABLESPACE registros_cientificos
  DATAFILE 'registros_cientificos.dat'
  SIZE 20M AUTOEXTEND ON;

--------------- Creación Cluster ----------------------------------

CREATE CLUSTER sensor_medida_cluster (sensor_serial VARCHAR(25))
SIZE  8192	    		
PCTFREE  5
TABLESPACE  registros_medidas
STORAGE( INITIAL 100M);

CREATE CLUSTER ubicacion_barrio_cluster (codigo_barrio VARCHAR2(10))
SIZE  8192	    		
PCTFREE  5
TABLESPACE  registros_geograficos
STORAGE( INITIAL 100M);

--------------- Creación Archivos Aleatorios

CREATE CLUSTER cientifico_responsable_AA (tipo_documento VARCHAR2(5),documento VARCHAR2(10) )
	TABLESPACE registros_cientificos
    HASHKEYS  1001
	SIZE 8192;



CREATE CLUSTER rango_cluster_AA (id_rango VARCHAR2(10))
	TABLESPACE registros_alertas
	HASHKEYS  1001
	SIZE 8192;
   
CREATE CLUSTER grupo_poblacional_cluster_AA (id_grupo_poblacional VARCHAR2(5))
	TABLESPACE registros_alertas
	HASHKEYS  1001
	SIZE 8192;
    
   
CREATE CLUSTER riesgo_cluster_AA (codigo_riesgo VARCHAR2(8))
	TABLESPACE registros_alertas
	HASHKEYS  1001
	SIZE 8192;
          

    
--------------- Creacion tablas ----------------------------------


CREATE TABLE afeccion (
    id_grupo_poblacional   VARCHAR2(5) NOT NULL,
    riesgo_codigo_riesgo   VARCHAR2(8) NOT NULL,
    PRIMARY KEY (id_grupo_poblacional,riesgo_codigo_riesgo)
)
ORGANIZATION INDEX TABLESPACE registros_alertas
PCTTHRESHOLD 20 
OVERFLOW TABLESPACE registros_alertas2;


--------------- ----------------------------------

CREATE TABLE auditoria_rango (
    autor                      VARCHAR2(45) NOT NULL,
    limite_inferior_anterior   NUMBER(5, 4) NOT NULL,
    limite_superior_anterior   NUMBER(5, 4),
    rango_id_rango             VARCHAR2(10) NOT NULL,
    fecha_hora_modificacion    TIMESTAMP,
    PRIMARY KEY(rango_id_rango)
);



--------------- ----------------------------------

CREATE TABLE barrio (
    codigo_barrio      VARCHAR2(10) NOT NULL,
    nombre             VARCHAR2(64) NOT NULL,
    zona_codigo_zona   VARCHAR2(5) NOT NULL,
    PRIMARY KEY(codigo_barrio)
)
CLUSTER ubicacion_barrio_cluster(codigo_barrio);

--------------- ----------------------------------

CREATE TABLE cientifico_responsable (
    tipo_documento           VARCHAR2(5) NOT NULL,
    documento                VARCHAR2(10) NOT NULL,
    nombre                   VARCHAR2(45) NOT NULL,
    email                    VARCHAR2(254) NOT NULL,
    telefono                 NUMBER(10),
    codigo_tipo_cientifico   VARCHAR2(3) NOT NULL,
    PRIMARY KEY(tipo_documento,documento)
	
)
CLUSTER  cientifico_responsable_AA(tipo_documento,documento);


-------------- ---------------------------------


CREATE TABLE grupo_poblacional (
    id_grupo_poblacional            VARCHAR2(5) NOT NULL,
    nombre_grupo_poblacional        VARCHAR2(64) NOT NULL,
    descripcion_grupo_poblacional   VARCHAR2(256) NOT NULL,
    PRIMARY KEY(id_grupo_poblacional)
)
CLUSTER grupo_poblacional_cluster_AA(id_grupo_poblacional);

CREATE INDEX i_grupopoblacional_nombre ON grupo_poblacional(nombre_grupo_poblacional )
	tablespace registros_alertas
	PCTFREE  5
	storage( INITIAL  50M);
-------------- ---------------------------------


CREATE TABLE medida (
    fecha_hora      TIMESTAMP NOT NULL,
    valor           NUMBER(3, 3) NOT NULL CHECK (valor >=0),
    sensor_serial   VARCHAR2(25) NOT NULL,
    PRIMARY KEY(fecha_hora,sensor_serial)
)
CLUSTER  sensor_medida_cluster(sensor_serial);


-------------- ---------------------------------

CREATE TABLE rango (
    id_rango                         VARCHAR2(10) NOT NULL,
    limite_inferior                  NUMBER(5, 4) NOT NULL,
    limite_superior                  NUMBER(5, 4),
    color                            VARCHAR2(25) DEFAULT 'Blanco' NOT NULL,
    tipo_medida_codigo_tipo_medida   VARCHAR2(5) NOT NULL,
    PRIMARY KEY (id_rango)
)
 CLUSTER   rango_cluster_AA(id_rango);

-------------- ---------------------------------

CREATE TABLE rangoxafeccion (
    rango_id_rango                  VARCHAR2(10) NOT NULL,
    afeccion_id_grupo_poblacional   VARCHAR2(5) NOT NULL,
    afeccion_codigo_riesgo          VARCHAR2(8) NOT NULL,
    PRIMARY KEY(rango_id_rango,afeccion_id_grupo_poblacional,afeccion_codigo_riesgo)
)
ORGANIZATION INDEX TABLESPACE registros_alertas
PCTTHRESHOLD 20 
OVERFLOW TABLESPACE registros_alertas2;

-------------- ---------------------------------

CREATE TABLE reporte (
    id_reporte         VARCHAR2(10) NOT NULL,
    fecha              TIMESTAMP NOT NULL,
    nombre_autor       VARCHAR2(45),
    cuerpo_reporte     VARCHAR2(1000) NOT NULL,
    zona_codigo_zona   VARCHAR2(5) NOT NULL,
    verificacion       VARCHAR2(16) DEFAULT 'En Verificación' NOT NULL
)

 Tablespace registros_medidas
 PCTFREE  5			 
 STORAGE(INITIAL 500M
	    NEXT		100M  );
        
ALTER TABLE reporte
    ADD CHECK ( verificacion IN (
        'En Verificación',
        'Invalido',
        'Valido'
    ) );

CREATE INDEX i_reporte ON Reporte(id_reporte)
	tablespace registros_reportes
	PCTFREE  5
	storage( INITIAL  50M);

ALTER TABLE reporte ADD CONSTRAINT id_reporte_pk PRIMARY KEY (id_reporte) USING INDEX i_reporte;


CREATE INDEX i_reporte_fecha_zona ON Reporte(Fecha, zona_codigo_zona)
	tablespace registros_reportes
	PCTFREE  5
	storage( INITIAL  50M);

CREATE INDEX i_reporte_verificacion ON Reporte(verificacion)
	tablespace registros_reportes
	PCTFREE  5
	storage( INITIAL  50M);

-------------- ---------------------------------

CREATE TABLE riesgo (
    codigo_riesgo        VARCHAR2(8) NOT NULL,
    categoria_riesgo     VARCHAR2(64) NOT NULL,
    descripcion_riesgo   VARCHAR2(256) NOT NULL,
    PRIMARY KEY(codigo_riesgo)
)
CLUSTER riesgo_cluster_AA(codigo_riesgo);

-------------- ---------------------------------

CREATE TABLE sensor (
    serial                           VARCHAR2(25) NOT NULL,
    ubicacion_latitud                NUMBER(2, 8) NOT NULL,
    ubicacion_longitud               NUMBER(2, 8) NOT NULL,
    tipo_medida_codigo_tipo_medida   VARCHAR2(5) NOT NULL,
    PRIMARY KEY(serial)
)
CLUSTER  sensor_medida_cluster(serial);

-------------- ---------------------------------

CREATE TABLE tipo_cientifico (
    codigo_tipo_científico   VARCHAR2(3) NOT NULL,
    nombre_tipo              VARCHAR2(64) NOT NULL,
    PRIMARY KEY (codigo_tipo_científico)
)
 TABLESPACE registros_cientificos
 PCTFREE 5 
 STORAGE (INITIAL 200M NEXT 50M );

ALTER TABLE tipo_cientifico
    ADD CHECK ( nombre_tipo IN (
        'Ciudadano',
        'Profesional'
    ) );

-----Indice default de Oracle -------------

-------------- ---------------------------------
CREATE TABLE tipo_medida (
    codigo_tipo_medida   VARCHAR2(5) NOT NULL,
    nombre               VARCHAR2(45) NOT NULL,
    unidad_de_medida     VARCHAR2(8) NOT NULL,
    PRIMARY KEY(codigo_tipo_medida)
)
 TABLESPACE registros_cientificos
 PCTFREE 5 
 STORAGE (INITIAL 200M NEXT 50M );

-----Indice default de Oracle -------------

-------------- ---------------------------------

CREATE TABLE ubicacion (
    latitud                     NUMBER(2, 8) NOT NULL,
    longitud                    NUMBER(2, 8) NOT NULL,
    descripcion                 VARCHAR2(64),
    barrio_codigo_barrio        VARCHAR2(10) NOT NULL,
    cientifico_tipo_documento   VARCHAR2(5) NOT NULL,
    cientifico_documento        VARCHAR2(10) NOT NULL,
    PRIMARY KEY(latitud,longitud)
)
CLUSTER ubicacion_barrio_cluster(barrio_codigo_barrio);
-------------- ---------------------------------

CREATE TABLE zona (
    codigo_zona   VARCHAR2(5) NOT NULL,
    nombre        VARCHAR2(25) NOT NULL
)
TABLESPACE registros_geograficos 
 PCTFREE 5 
 STORAGE (INITIAL 100M NEXT 20M );

CREATE INDEX i_zona ON zona(codigo_zona)
	tablespace registros_geograficos
	PCTFREE  5
	storage( INITIAL  50M);

ALTER TABLE ZONA ADD CONSTRAINT codigo_zona_pk PRIMARY KEY (codigo_zona) USING INDEX i_zona;

ALTER TABLE zona ADD CONSTRAINT zona_nombre_un UNIQUE ( nombre );


-------------------CLUSTER INDEX------------------

CREATE INDEX  I_sensor_medida_c  ON CLUSTER  sensor_medida_cluster
PCTFREE 5  		TABLESPACE registros_medidas 
STORAGE( INITIAL 50M);

CREATE INDEX  I_ubicacion_barrio_c  ON CLUSTER  ubicacion_barrio_cluster
PCTFREE 5  		TABLESPACE registros_geograficos
STORAGE( INITIAL 50M);

-------------- Alters Tablas Foreign Key Constraints ---------------------------------

ALTER TABLE afeccion
    ADD CONSTRAINT afeccion_grupo_poblacional_fk FOREIGN KEY ( id_grupo_poblacional )
        REFERENCES grupo_poblacional ( id_grupo_poblacional );

ALTER TABLE afeccion
    ADD CONSTRAINT afeccion_riesgo_fk FOREIGN KEY ( riesgo_codigo_riesgo )
        REFERENCES riesgo ( codigo_riesgo );

ALTER TABLE auditoria_rango
    ADD CONSTRAINT auditoria_rango_rango_fk FOREIGN KEY ( rango_id_rango )
        REFERENCES rango ( id_rango );

ALTER TABLE barrio
    ADD CONSTRAINT barrio_zona_fk FOREIGN KEY ( zona_codigo_zona )
        REFERENCES zona ( codigo_zona );

ALTER TABLE cientifico_responsable
    ADD CONSTRAINT cientifico_tipo_cientifico_fk FOREIGN KEY ( codigo_tipo_cientifico )
        REFERENCES tipo_cientifico ( codigo_tipo_científico );

ALTER TABLE medida
    ADD CONSTRAINT medida_sensor_fk FOREIGN KEY ( sensor_serial )
        REFERENCES sensor ( serial );

ALTER TABLE rango
    ADD CONSTRAINT rango_tipo_medida_fk FOREIGN KEY ( tipo_medida_codigo_tipo_medida )
        REFERENCES tipo_medida ( codigo_tipo_medida );

ALTER TABLE rangoxafeccion
    ADD CONSTRAINT rangoxafeccion_afeccion_fk FOREIGN KEY ( afeccion_id_grupo_poblacional,
                                                            afeccion_codigo_riesgo )
        REFERENCES afeccion ( id_grupo_poblacional,
                              riesgo_codigo_riesgo );

ALTER TABLE rangoxafeccion
    ADD CONSTRAINT rangoxafeccion_rango_fk FOREIGN KEY ( rango_id_rango )
        REFERENCES rango ( id_rango );

ALTER TABLE reporte
    ADD CONSTRAINT reporte_zona_fk FOREIGN KEY ( zona_codigo_zona )
        REFERENCES zona ( codigo_zona );

ALTER TABLE sensor
    ADD CONSTRAINT sensor_tipo_medida_fk FOREIGN KEY ( tipo_medida_codigo_tipo_medida )
        REFERENCES tipo_medida ( codigo_tipo_medida );

ALTER TABLE sensor
    ADD CONSTRAINT sensor_ubicacion_fk FOREIGN KEY ( ubicacion_latitud,
                                                     ubicacion_longitud )
        REFERENCES ubicacion ( latitud,
                               longitud );

ALTER TABLE ubicacion
    ADD CONSTRAINT ubicacion_barrio_fk FOREIGN KEY ( barrio_codigo_barrio )
        REFERENCES barrio ( codigo_barrio );

ALTER TABLE ubicacion
    ADD CONSTRAINT ubicacion_cientifico_fk FOREIGN KEY ( cientifico_tipo_documento,
                                                         cientifico_documento )
        REFERENCES cientifico_responsable ( tipo_documento,
                                            documento );
