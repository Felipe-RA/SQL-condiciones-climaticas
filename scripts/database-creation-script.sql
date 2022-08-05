--------------- Creación TableSpace ----------------------------------

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

CREATE CLUSTER ubicacion_cluster (Latitud NUMBER (2,8),Longitud NUMBER (2,8))
SIZE  8192	    		
PCTFREE  5
TABLESPACE  registros_geograficos
STORAGE( INITIAL 100M);	

--------------- Creación Archivos Aleatorios ----------------------------------

CREATE CLUSTER cientifico_responsable_cluster ( tipo_documento VARCHAR2(5) ,documento VARCHAR2(10) )
	TABLESPACE registros_cientificos
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER zona_cluster (codigo_zona VARCHAR2(5))
	TABLESPACE registros_geograficos
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER rango_cluster (id_rango VARCHAR2(10))
	TABLESPACE registros_alertas
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER grupo_poblacional_cluster (id_grupo_poblacional VARCHAR2(5))
	TABLESPACE registros_alertas
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER tipo_medida_cluster (codigo_tipo_medida VARCHAR2(5))
	TABLESPACE registros_alertas
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER riesgo_cluster (codigo_riesgo VARCHAR2(8))
	TABLESPACE registros_alertas
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER tipo_cientifico_cluster (codigo_tipo_cientifico VARCHAR2(3))
	TABLESPACE registros_cientificos
	HASHKEY  1001
	SIZE 8192;

CREATE CLUSTER barrio_cluster (codigo_barrio VARCHAR2(10))
	TABLESPACE rregistros_geograficos
	HASHKEY  1001
	SIZE 8192;






--------------- Creación tablas ----------------------------------


CREATE TABLE afeccion (
    id_grupo_poblacional   VARCHAR2(5) NOT NULL,
    riesgo_codigo_riesgo   VARCHAR2(8) NOT NULL
)
ORGANIZATION INDEX TABLESPACE registros_alertas
PCTTHRESHOLD 20 
OVERFLOW TABLESPACE registros_alertas2;



ALTER TABLE afeccion ADD CONSTRAINT afeccion_pk PRIMARY KEY ( id_grupo_poblacional,
                                                              riesgo_codigo_riesgo );

ALTER TABLE afeccion
    ADD CONSTRAINT afeccion_grupo_poblacional_fk FOREIGN KEY ( id_grupo_poblacional )
        REFERENCES grupo_poblacional ( id_grupo_poblacional );

ALTER TABLE afeccion
    ADD CONSTRAINT afeccion_riesgo_fk FOREIGN KEY ( riesgo_codigo_riesgo )
        REFERENCES riesgo ( codigo_riesgo );

--------------- ----------------------------------

CREATE TABLE auditoria_rango (
    autor                      VARCHAR2(45) NOT NULL,
    limite_inferior_anterior   NUMBER(5, 4) NOT NULL,
    limite_superior_anterior   NUMBER(5, 4),
    rango_id_rango             VARCHAR2(10) NOT NULL,
    fecha_hora_modificacion    TIMESTAMP
);

ALTER TABLE auditoria_rango ADD CONSTRAINT auditoria_rango_pk PRIMARY KEY ( rango_id_rango );

ALTER TABLE auditoria_rango
    ADD CONSTRAINT auditoria_rango_rango_fk FOREIGN KEY ( rango_id_rango )
        REFERENCES rango ( id_rango );

--------------- ----------------------------------

CREATE TABLE barrio (
    codigo_barrio      VARCHAR2(10) NOT NULL,
    nombre             VARCHAR2(64) NOT NULL,
    zona_codigo_zona   VARCHAR2(5) NOT NULL
);

ALTER TABLE barrio ADD CONSTRAINT barrio_pk PRIMARY KEY ( codigo_barrio );

ALTER TABLE barrio
    ADD CONSTRAINT barrio_zona_fk FOREIGN KEY ( zona_codigo_zona )
        REFERENCES zona ( codigo_zona );


--------------- ----------------------------------

CREATE TABLE cientifico_responsable (
    tipo_documento           VARCHAR2(5) NOT NULL,
    documento                VARCHAR2(10) NOT NULL,
    nombre                   VARCHAR2(45) NOT NULL,
    email                    VARCHAR2(254) NOT NULL,
    telefono                 NUMBER(10),
    codigo_tipo_científico   VARCHAR2(3) NOT NULL
	
)
CLUSTER  cientifico_responsable_cluster(tipo_documento,documento);

ALTER TABLE cientifico_responsable ADD CONSTRAINT cientifico_responsable_pk PRIMARY KEY ( tipo_documento,

ALTER TABLE cientifico_responsable
    ADD CONSTRAINT cientifico_tipo_cientifico_fk FOREIGN KEY ( codigo_tipo_científico )
        REFERENCES tipo_cientifico ( codigo_tipo_científico );                                                                                        documento );


-------------- ---------------------------------


CREATE TABLE grupo_poblacional (
    id_grupo_poblacional            VARCHAR2(5) NOT NULL,
    nombre_grupo_poblacional        VARCHAR2(64) NOT NULL,
    descripcion_grupo_poblacional   VARCHAR2(256) NOT NULL
);

ALTER TABLE grupo_poblacional ADD CONSTRAINT grupo_poblacional_pk PRIMARY KEY ( id_grupo_poblacional );


-------------- ---------------------------------


CREATE TABLE medida (
    fecha_hora      TIMESTAMP NOT NULL,
    valor           NUMBER(3, 3) NOT NULL CHECK (valor >=0),
    sensor_serial   VARCHAR2(25) NOT NULL
)
CLUSTER  sensor_medida_cluster(sensor_serial);

ALTER TABLE medida ADD CHECK ( valor = 0 );

ALTER TABLE medida ADD CONSTRAINT medida_pk PRIMARY KEY ( fecha_hora,
                                                          sensor_serial );

ALTER TABLE medida
    ADD CONSTRAINT medida_sensor_fk FOREIGN KEY ( sensor_serial )
        REFERENCES sensor ( serial );

-------------- ---------------------------------

CREATE TABLE rango (
    id_rango                         VARCHAR2(10) NOT NULL,
    limite_inferior                  NUMBER(5, 4) NOT NULL,
    limite_superior                  NUMBER(5, 4),
    color                            VARCHAR2(25) DEFAULT 'Blanco' NOT NULL,
    tipo_medida_codigo_tipo_medida   VARCHAR2(5) NOT NULL
);

ALTER TABLE rango ADD CONSTRAINT rango_pk PRIMARY KEY ( id_rango );

ALTER TABLE rango
    ADD CONSTRAINT rango_tipo_medida_fk FOREIGN KEY ( tipo_medida_codigo_tipo_medida )
        REFERENCES tipo_medida ( codigo_tipo_medida );

-------------- ---------------------------------

CREATE TABLE rangoxafeccion (
    rango_id_rango                  VARCHAR2(10) NOT NULL,
    afeccion_id_grupo_poblacional   VARCHAR2(5) NOT NULL,
    afeccion_codigo_riesgo          VARCHAR2(8) NOT NULL
)
ORGANIZATION INDEX TABLESPACE registros_alertas
PCTTHRESHOLD 20 
OVERFLOW TABLESPACE registros_alertas2;

ALTER TABLE rangoxafeccion
    ADD CONSTRAINT rangoxafeccion_pk PRIMARY KEY ( rango_id_rango,
                                                   afeccion_id_grupo_poblacional,
                                                   afeccion_codigo_riesgo );
ALTER TABLE rangoxafeccion
    ADD CONSTRAINT rangoxafeccion_afeccion_fk FOREIGN KEY ( afeccion_id_grupo_poblacional,
                                                            afeccion_codigo_riesgo )
        REFERENCES afeccion ( id_grupo_poblacional,
                              riesgo_codigo_riesgo );

ALTER TABLE rangoxafeccion
    ADD CONSTRAINT rangoxafeccion_rango_fk FOREIGN KEY ( rango_id_rango )
        REFERENCES rango ( id_rango );

-------------- ---------------------------------

CREATE TABLE reporte (
    id_reporte         VARCHAR2(10) NOT NULL,
    fecha              TIMESTAMP NOT NULL,
    nombre_autor       VARCHAR2(45),
    cuerpo_reporte     VARCHAR2(1000) NOT NULL,
    zona_codigo_zona   VARCHAR2(5) NOT NULL,
    verificacion       VARCHAR2(16) DEFAULT 'En Verificación' NOT NULL
);

ALTER TABLE reporte
    ADD CHECK ( verificacion IN (
        'En Verificación',
        'Invalido',
        'Valido'
    ) );

ALTER TABLE reporte ADD CONSTRAINT reporte_pk PRIMARY KEY ( id_reporte );

ALTER TABLE reporte
    ADD CONSTRAINT reporte_zona_fk FOREIGN KEY ( zona_codigo_zona )
        REFERENCES zona ( codigo_zona );

 Tablespace registros_medidas
 PCTFREE  5			CACHE
 STORAGE (INITIAL		50OM
	    NEXT		100M  );

CREATE INDEX i_reporte ON Reporte(id_reporte)
	tablespace registros_reportes
	PCTFREE  5
	storage( INITIAL  50M);


-------------- ---------------------------------

CREATE TABLE riesgo (
    codigo_riesgo        VARCHAR2(8) NOT NULL,
    categoria_riesgo     VARCHAR2(64) NOT NULL,
    descripción_riesgo   VARCHAR2(256) NOT NULL
);


ALTER TABLE riesgo ADD CONSTRAINT riesgo_pk PRIMARY KEY ( codigo_riesgo );

ALTER TABLE riesgo ADD CONSTRAINT riesgo_pk PRIMARY KEY ( codigo_riesgo );

-------------- ---------------------------------


CREATE TABLE sensor (
    serial                           VARCHAR2(25) NOT NULL,
    ubicacion_latitud                NUMBER(2, 8) NOT NULL,
    ubicacion_longitud               NUMBER(2, 8) NOT NULL,
    tipo_medida_codigo_tipo_medida   VARCHAR2(5) NOT NULL
)
CLUSTER  sensor_medida_cluster(serial);

ALTER TABLE sensor
    ADD CONSTRAINT sensor_ubicacion_fk FOREIGN KEY ( ubicacion_latitud,
                                                     ubicacion_longitud )
        REFERENCES ubicacion ( latitud,
                               longitud );

-------------- ---------------------------------

ALTER TABLE tipo_cientifico
    ADD CHECK ( nombre_tipo IN (
        'Ciudadano',
        'Profesional'
    ) );

ALTER TABLE tipo_cientifico ADD CONSTRAINT tipo_cientifico_pk PRIMARY KEY ( codigo_tipo_científico );

-------------- ---------------------------------

CREATE TABLE tipo_medida (
    codigo_tipo_medida   VARCHAR2(5) NOT NULL,
    nombre               VARCHAR2(45) NOT NULL,
    unidad_de_medida     VARCHAR2(8) NOT NULL
);

ALTER TABLE tipo_medida ADD CONSTRAINT tipo_medida_pk PRIMARY KEY ( codigo_tipo_medida );

ALTER TABLE tipo_medida ADD CONSTRAINT unidad_de_medida_un UNIQUE ( unidad_de_medida );

-------------- ---------------------------------

CREATE TABLE ubicacion (
    latitud                     NUMBER(2, 8) NOT NULL,
    longitud                    NUMBER(2, 8) NOT NULL,
    descripción                 VARCHAR2(64),
    barrio_codigo_barrio        VARCHAR2(10) NOT NULL,
    cientifico_tipo_documento   VARCHAR2(5) NOT NULL,
    cientifico_documento        VARCHAR2(10) NOT NULL
)
CLUSTER  ubicacion_cluster(latitud,longitud);

ALTER TABLE ubicacion ADD CONSTRAINT ubicacion_pk PRIMARY KEY ( latitud,
                                                                longitud );

ALTER TABLE ubicacion
    ADD CONSTRAINT ubicacion_barrio_fk FOREIGN KEY ( barrio_codigo_barrio )
        REFERENCES barrio ( codigo_barrio );

ALTER TABLE ubicacion
    ADD CONSTRAINT ubicacion_cientifico_fk FOREIGN KEY ( cientifico_tipo_documento,
                                                         cientifico_documento )
        REFERENCES cientifico_responsable ( tipo_documento,
                                            documento );

-------------- ---------------------------------

CREATE TABLE zona (
    codigo_zona   VARCHAR2(5) NOT NULL,
    nombre        VARCHAR2(25) NOT NULL
)
CLUSTER  zona_cluster(codigo_zona);

ALTER TABLE zona ADD CONSTRAINT zona_pk PRIMARY KEY ( codigo_zona );

ALTER TABLE zona ADD CONSTRAINT zona_nombre_un UNIQUE ( nombre );














