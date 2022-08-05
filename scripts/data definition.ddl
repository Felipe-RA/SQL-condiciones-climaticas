-- Generado por Oracle SQL Developer Data Modeler 19.2.0.182.1216
--   en:        2019-09-12 18:00:59 COT
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLE afeccion (
    id_grupo_poblacional   VARCHAR2(5) NOT NULL,
    riesgo_codigo_riesgo   VARCHAR2(8) NOT NULL
);

COMMENT ON TABLE afeccion IS
    'Entidad de Intersecci�n entre RiesgoxGrupo_Poblacional. Permite identificar los m�ltiples riesgos que pueden afectar a m�ltiples Grupos_Poblacionales'
    ;

COMMENT ON COLUMN afeccion.id_grupo_poblacional IS
    'Identificador del Grupo Poblacional Afectado.';

COMMENT ON COLUMN afeccion.riesgo_codigo_riesgo IS
    'Identificador  del Riesgo que afecta el Grupo Poblacional.';

ALTER TABLE afeccion ADD CONSTRAINT afeccion_pk PRIMARY KEY ( id_grupo_poblacional,
                                                              riesgo_codigo_riesgo );

CREATE TABLE auditoria_rango (
    autor                      VARCHAR2(45) NOT NULL,
    limite_inferior_anterior   NUMBER(5, 4) NOT NULL,
    limite_superior_anterior   NUMBER(5, 4),
    rango_id_rango             VARCHAR2(10) NOT NULL,
    fecha_hora_modificacion    TIMESTAMP
);

COMMENT ON TABLE auditoria_rango IS
    'Entidad en la que se almacenan los cambios realizados sobre los registros rango, ya que estos se consideran sensibles para determinar un Riesgo que causa Afecciones sobre un Grupo Poblacional'
    ;

COMMENT ON COLUMN auditoria_rango.autor IS
    'Autor de la modificaci�n realizada en la tabla Rango.';

COMMENT ON COLUMN auditoria_rango.limite_inferior_anterior IS
    'Limite Inferior anterior del Rango modificado.';

COMMENT ON COLUMN auditoria_rango.limite_superior_anterior IS
    'Limite Superior Anterior del Rango modificado.';

COMMENT ON COLUMN auditoria_rango.rango_id_rango IS
    'ID del Rango modificado';

COMMENT ON COLUMN auditoria_rango.fecha_hora_modificacion IS
    'Fecha y hora del sistema en la que se realiz� el cambio en Rango.';

ALTER TABLE auditoria_rango ADD CONSTRAINT auditoria_rango_pk PRIMARY KEY ( rango_id_rango );

CREATE TABLE barrio (
    codigo_barrio      VARCHAR2(10) NOT NULL,
    nombre             VARCHAR2(64) NOT NULL,
    zona_codigo_zona   VARCHAR2(5) NOT NULL
);

COMMENT ON TABLE barrio IS
    'Divisi�n Territorial que se define como un conjunto de ubicaciones caracteizado con un nombre y que pertenece a una zona.';

COMMENT ON COLUMN barrio.codigo_barrio IS
    'C�digo que identifica �nicamente un Barrio.';

COMMENT ON COLUMN barrio.nombre IS
    'Nombre que caracteriza al Barrio';

COMMENT ON COLUMN barrio.zona_codigo_zona IS
    'C�digo de la Zona en la que se encuentra el Barrio.';

ALTER TABLE barrio ADD CONSTRAINT barrio_pk PRIMARY KEY ( codigo_barrio );

CREATE TABLE cientifico_responsable (
    tipo_documento           VARCHAR2(5) NOT NULL,
    documento                VARCHAR2(10) NOT NULL,
    nombre                   VARCHAR2(45) NOT NULL,
    email                    VARCHAR2(254) NOT NULL,
    telefono                 NUMBER(10),
    codigo_tipo_cient�fico   VARCHAR2(3) NOT NULL
);

COMMENT ON TABLE cientifico_responsable IS
    'Cient�fico encargado de una ubicaci�n donde se encuentran los sensores. Puede ser de tipo Ciudadano u Oficial.';

COMMENT ON COLUMN cientifico_responsable.tipo_documento IS
    'Tipo de documento legal que posee el Cient�fico Responsable.';

COMMENT ON COLUMN cientifico_responsable.documento IS
    'Documento que en conjunto con el Tipo de Documento identifica inequivocamente a un Cient�fico Responsable.';

COMMENT ON COLUMN cientifico_responsable.nombre IS
    'Nombre del Cient�fico Responsable.';

COMMENT ON COLUMN cientifico_responsable.email IS
    'Correo electr�nico de contacto perteneciente al Cient�fico Responsable.';

COMMENT ON COLUMN cientifico_responsable.telefono IS
    'Tel�fono celular o fijo de contacto.';

COMMENT ON COLUMN cientifico_responsable.codigo_tipo_cient�fico IS
    'Indica el Tipo de Cientifico que es el Cientifico Responsable.';

ALTER TABLE cientifico_responsable ADD CONSTRAINT cientifico_responsable_pk PRIMARY KEY ( tipo_documento,
                                                                                          documento );

CREATE TABLE grupo_poblacional (
    id_grupo_poblacional            VARCHAR2(5) NOT NULL,
    nombre_grupo_poblacional        VARCHAR2(64) NOT NULL,
    descripcion_grupo_poblacional   VARCHAR2(256) NOT NULL
);

COMMENT ON TABLE grupo_poblacional IS
    'Un Grupo Poblacional es un conjunto de personas que poseen caracter�sticas en com�n que permiten agruparles. Un Grupos Poblacionales pueden ser susceptibles a m�ltiples riesgos.'
    ;

COMMENT ON COLUMN grupo_poblacional.id_grupo_poblacional IS
    'Identificador �nico del Grupo_Poblacional.';

COMMENT ON COLUMN grupo_poblacional.nombre_grupo_poblacional IS
    'Nombre del Grupo Poblacional. EJ: "Adultos Mayores", "Ni�os", "Adultos Sanos".';

COMMENT ON COLUMN grupo_poblacional.descripcion_grupo_poblacional IS
    'Texto que informe sobre el Grupo Poblaciona. EJ: "Se considera adulto sano a cualquier hombre y mujer mayor a 20 a�os que no sufra enfermedades graves o incapacitantes".'
    ;

ALTER TABLE grupo_poblacional ADD CONSTRAINT grupo_poblacional_pk PRIMARY KEY ( id_grupo_poblacional );

CREATE TABLE medida (
    fecha_hora      TIMESTAMP NOT NULL,
    valor           NUMBER(3, 3) NOT NULL CHECK (valor >=0),
    sensor_serial   VARCHAR2(25) NOT NULL
);

ALTER TABLE medida ADD CHECK ( valor = 0 );

COMMENT ON TABLE medida IS
    'Medida es un valor capturado por un sensor con un Tipo de Medida. ';

COMMENT ON COLUMN medida.fecha_hora IS
    'Fecha, hora y minuto en la que fue tomada la Medida.';

COMMENT ON COLUMN medida.valor IS
    'Valor de la medici�n ambiental capturada por un sensor de uno Tipo de Medici�n espec�fica.';

COMMENT ON COLUMN medida.sensor_serial IS
    'Serial del Sensor que capturo la Medida.';

ALTER TABLE medida ADD CONSTRAINT medida_pk PRIMARY KEY ( fecha_hora,
                                                          sensor_serial );

CREATE TABLE rango (
    id_rango                         VARCHAR2(10) NOT NULL,
    limite_inferior                  NUMBER(5, 4) NOT NULL,
    limite_superior                  NUMBER(5, 4),
    color                            VARCHAR2(25) DEFAULT 'Blanco' NOT NULL,
    tipo_medida_codigo_tipo_medida   VARCHAR2(5) NOT NULL
);

COMMENT ON TABLE rango IS
    'Un rango es el Limite Inferior y Superior en el cual un tipo de medida recibe una caracterizaci�n espec�fica. El rango debe poseer un nombre que describa qu� ocurre entre los valores del l�mite superior e inferior. Algunos rangos no poseen l�mite superior. Los rangos poseen un color que por default es blanco.'
    ;

COMMENT ON COLUMN rango.id_rango IS
    'Identificador �nico del Rango.';

COMMENT ON COLUMN rango.limite_inferior IS
    'Limite Inferior de un Rango. ';

COMMENT ON COLUMN rango.limite_superior IS
    'Limite Superior de un Rango.';

COMMENT ON COLUMN rango.color IS
    'Color asignado al Rango.';

COMMENT ON COLUMN rango.tipo_medida_codigo_tipo_medida IS
    'C�digo del Tipo de Medida del Rango.';

ALTER TABLE rango ADD CONSTRAINT rango_pk PRIMARY KEY ( id_rango );

CREATE TABLE rangoxafeccion (
    rango_id_rango                  VARCHAR2(10) NOT NULL,
    afeccion_id_grupo_poblacional   VARCHAR2(5) NOT NULL,
    afeccion_codigo_riesgo          VARCHAR2(8) NOT NULL
);

COMMENT ON TABLE rangoxafeccion IS
    'Tabla de Interseccion entre los Rangos y RiesgoXGrupo_Poblacional. Permite identificar los m�ltiples rangos de m�ltiples afecciones.'
    ;

COMMENT ON COLUMN rangoxafeccion.rango_id_rango IS
    'Rango en el que se presenta  la Afecci�n.';

COMMENT ON COLUMN rangoxafeccion.afeccion_id_grupo_poblacional IS
    'Identificador del Grupo Poblacional Afectado en el Rango.';

COMMENT ON COLUMN rangoxafeccion.afeccion_codigo_riesgo IS
    'C�digo del Riesgo que genera la Afecci�n en el Rango.';

ALTER TABLE rangoxafeccion
    ADD CONSTRAINT rangoxafeccion_pk PRIMARY KEY ( rango_id_rango,
                                                   afeccion_id_grupo_poblacional,
                                                   afeccion_codigo_riesgo );

CREATE TABLE reporte (
    id_reporte         VARCHAR2(10) NOT NULL,
    fecha              TIMESTAMP NOT NULL,
    nombre_autor       VARCHAR2(45),
    cuerpo_reporte     VARCHAR2(1000) NOT NULL,
    zona_codigo_zona   VARCHAR2(5) NOT NULL,
    verificacion       VARCHAR2(16) DEFAULT 'En Verificaci�n' NOT NULL
);

ALTER TABLE reporte
    ADD CHECK ( verificacion IN (
        'En Verificaci�n',
        'Invalido',
        'Valido'
    ) );

COMMENT ON TABLE reporte IS
    'Un reporte es informaci�n relacionada con una zona que es depositada por un usuario Estos reportes deber�n de contener un cuerpo no mayor a 1000 caracteres que describan el reporte y deben especificar al zona en la cual se realizan, as� como la fecha y opcionalmente el autor.'
    ;

COMMENT ON COLUMN reporte.id_reporte IS
    'Identificador �nico de un Reporte';

COMMENT ON COLUMN reporte.fecha IS
    'Fecha  en la que el Reporte fue realizado.';

COMMENT ON COLUMN reporte.nombre_autor IS
    'Campo opcional que contiene el nombre del autor del Reporte.';

COMMENT ON COLUMN reporte.cuerpo_reporte IS
    'Contenido del Reporte.';

COMMENT ON COLUMN reporte.zona_codigo_zona IS
    'C�digo de la Zona a la que se le hace el Reporte.';

COMMENT ON COLUMN reporte.verificacion IS
    'Atributo de auditor�a que indica si la informaci�n del reporte ha sido verificada. Puede ser "En Verificaci�n", "Valido" o "Invalido". Por defecto "En Verificaci�n"'
    ;

ALTER TABLE reporte ADD CONSTRAINT reporte_pk PRIMARY KEY ( id_reporte );

CREATE TABLE riesgo (
    codigo_riesgo        VARCHAR2(8) NOT NULL,
    categoria_riesgo     VARCHAR2(64) NOT NULL,
    descripci�n_riesgo   VARCHAR2(256) NOT NULL
);

COMMENT ON TABLE riesgo IS
    'Se define como riesgo a la posible afecci�n de un Grupo_Poblacional debido a un factor ambiental. Los riesgos surgen cuando estos factores ambientales se encuentran entre el Limite Inferior y Superior de un Intervalo. Los riesgos cambian seg�n el grupo poblacional al que afecten y el Tipo de Medida que causa el riesgo.'
    ;

COMMENT ON COLUMN riesgo.codigo_riesgo IS
    'Identificador �nico de un Riesgo. EJ: "IUV12", "PPM25123".';

COMMENT ON COLUMN riesgo.categoria_riesgo IS
    'Categoria en la que el Riesgo se encuentra clasificado. EJ: "Moderado", "Alto", "Moderadamente Sensible".';

COMMENT ON COLUMN riesgo.descripci�n_riesgo IS
    'Descripci�n del Riesgo como la afecci�n que puede causar. EJ: "Dificultad para respirar", "Quemaduras de Piel".';

ALTER TABLE riesgo ADD CONSTRAINT riesgo_pk PRIMARY KEY ( codigo_riesgo );

CREATE TABLE sensor (
    serial                           VARCHAR2(25) NOT NULL,
    ubicacion_latitud                NUMBER(2, 8) NOT NULL,
    ubicacion_longitud               NUMBER(2, 8) NOT NULL,
    tipo_medida_codigo_tipo_medida   VARCHAR2(5) NOT NULL
);

COMMENT ON TABLE sensor IS
    'Representa la entidad Sensor, que toma medidas, tiene una ubicaci�n y un tipo de medida.';

COMMENT ON COLUMN sensor.serial IS
    'Serial del Sensor que lo identifica de manera �nica.';

COMMENT ON COLUMN sensor.ubicacion_latitud IS
    'La distancia angular entre la l�nea ecuatorial y la ubicaci�n del Sensor.';

COMMENT ON COLUMN sensor.ubicacion_longitud IS
    'La distancia angular entre la ubicaci�n del Sensor y el meridiano Cero.';

COMMENT ON COLUMN sensor.tipo_medida_codigo_tipo_medida IS
    'Identifica el Tipo de Medida que captura el Sensor.';

ALTER TABLE sensor ADD CONSTRAINT sensor_pk PRIMARY KEY ( serial );

CREATE TABLE tipo_cientifico (
    codigo_tipo_cient�fico   VARCHAR2(3) NOT NULL,
    nombre_tipo              VARCHAR2(64) NOT NULL
);

ALTER TABLE tipo_cientifico
    ADD CHECK ( nombre_tipo IN (
        'Ciudadano',
        'Profesional'
    ) );

COMMENT ON TABLE tipo_cientifico IS
    'Tipos distintos  de cient�ficos responsables';

COMMENT ON COLUMN tipo_cientifico.codigo_tipo_cient�fico IS
    'Identificador �nico de un Tipo de Cient�fico.';

COMMENT ON COLUMN tipo_cientifico.nombre_tipo IS
    'Nombre que corresponde al Tipo de Cient�fico. Puede ser de tipo "Profesional" o "Ciudadano".';

ALTER TABLE tipo_cientifico ADD CONSTRAINT tipo_cientifico_pk PRIMARY KEY ( codigo_tipo_cient�fico );

CREATE TABLE tipo_medida (
    codigo_tipo_medida   VARCHAR2(5) NOT NULL,
    nombre               VARCHAR2(45) NOT NULL,
    unidad_de_medida     VARCHAR2(8) NOT NULL
);

COMMENT ON TABLE tipo_medida IS
    'Tipo de Medida que captura un Sensor. El Tipo de Medida debe poseer un nombre que la caracterice y una unidad de medida en la que el Sensor expresa sus mediciones'
    ;

COMMENT ON COLUMN tipo_medida.codigo_tipo_medida IS
    'Identificador �nico del Tipo de Medida.';

COMMENT ON COLUMN tipo_medida.nombre IS
    'Nombre que caracteriza el Tipo de Medida.';

COMMENT ON COLUMN tipo_medida.unidad_de_medida IS
    'Unidades en las que se expresa una Medici�n.';

ALTER TABLE tipo_medida ADD CONSTRAINT tipo_medida_pk PRIMARY KEY ( codigo_tipo_medida );

ALTER TABLE tipo_medida ADD CONSTRAINT unidad_de_medida_un UNIQUE ( unidad_de_medida );

CREATE TABLE ubicacion (
    latitud                     NUMBER(2, 8) NOT NULL,
    longitud                    NUMBER(2, 8) NOT NULL,
    descripci�n                 VARCHAR2(64),
    barrio_codigo_barrio        VARCHAR2(10) NOT NULL,
    cientifico_tipo_documento   VARCHAR2(5) NOT NULL,
    cientifico_documento        VARCHAR2(10) NOT NULL
);

COMMENT ON COLUMN ubicacion.latitud IS
    'La distancia angular entre la l�nea ecuatorial y una Ubicaci�n.';

COMMENT ON COLUMN ubicacion.longitud IS
    'La distancia angular entre un punto dado de la superficie terrestre y el meridiano cero.';

COMMENT ON COLUMN ubicacion.descripci�n IS
    'Campo opcional que contiene informaci�n adicional sobre la Ubicaci�n.';

COMMENT ON COLUMN ubicacion.barrio_codigo_barrio IS
    'C�digo del Barrio en el que se encuentra la Ubicaci�n.';

COMMENT ON COLUMN ubicacion.cientifico_tipo_documento IS
    'Tipo de Documento del Cient�fico Responsable de la Ubicaci�n.';

COMMENT ON COLUMN ubicacion.cientifico_documento IS
    'N�mero de Documento del Cient�fico responsable de la Ubicaci�n.';

ALTER TABLE ubicacion ADD CONSTRAINT ubicacion_pk PRIMARY KEY ( latitud,
                                                                longitud );

CREATE TABLE zona (
    codigo_zona   VARCHAR2(5) NOT NULL,
    nombre        VARCHAR2(25) NOT NULL
);

COMMENT ON TABLE zona IS
    'Una zona es un conjunto de barrios de acuerdo a la divisi�n pol�tica del valle de aburr�';

COMMENT ON COLUMN zona.codigo_zona IS
    'C�digo que describe inequivocamente a una Zona.';

COMMENT ON COLUMN zona.nombre IS
    'Nombre descriptivo de la Zona';

ALTER TABLE zona ADD CONSTRAINT zona_pk PRIMARY KEY ( codigo_zona );

ALTER TABLE zona ADD CONSTRAINT zona_nombre_un UNIQUE ( nombre );

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
    ADD CONSTRAINT cientifico_tipo_cientifico_fk FOREIGN KEY ( codigo_tipo_cient�fico )
        REFERENCES tipo_cientifico ( codigo_tipo_cient�fico );

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



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             0
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
