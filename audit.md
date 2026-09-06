# Audit UI/UX — Psyware SSL (psyware.ar)
Auditoría rápida (modo acotado por presupuesto de sesión) — 2026-09-06. Servido localmente en `localhost:8812`.

Páginas revisadas: Inicio (desktop + mobile 375px). **No revisadas en esta pasada:** acerca-de-nosotros.html, productos-y-servicios.html, cursos.html, diagnosticos.html (y sus 4 sub-diagnósticos), prensa.html, contacto.html — recomendable una segunda pasada.

## Hallazgos

### 1. Identidad visual inconsistente con Intelix (Alta prioridad, marca)
Psyware y Intelix son **la misma empresa** (fundada 2004, Psyware nació como "INTELIX Ingeniería & Telecomunicaciones" según el propio `llms.txt`), pero visualmente son irreconocibles como hermanas:
- Intelix: fondo oscuro, acentos dorados, tipografía Inter, botones `border-radius:8px`.
- Psyware: fondo blanco, hero en degradé azul brillante, botones tipo "pill" (`border-radius:999px`), tipografía Raleway para títulos.
Un prospecto que llega a ambos sitios (por ejemplo, buscando "peritaje informático Rosario" y luego "IA local Rosario") no va a conectar que hablan con el mismo proveedor. Esto diluye 20 años de trayectoria y las credenciales compartidas (único Training Center Yeastar, único partner Loway, peritos matriculados).
**Recomendación:** definir cuál identidad es la "marca madre" (sugerido: la de Intelix, más moderna y con mejor jerarquía tipográfica) y aplicar al menos paleta de color, tipografía y forma de botones compartidas entre ambos sitios, o agregar cross-linking explícito ("Psyware SSL es la marca de servicios de seguridad de Intelix" / viceversa) en ambos headers/footers.

### 2. Hero tipo carrusel con 9 slides (Media/Alta prioridad, conversión)
El hero es un carrusel automático con 9 puntos de navegación. Los carruseles tienen tasas de interacción muy bajas y bien documentadas (la gran mayoría de visitantes solo ve el primer slide y nunca interactúa con las flechas). Con 9 mensajes de valor distintos compitiendo por el primer slide, se diluye cuál es el mensaje principal de la empresa.
**Recomendación:** reducir a un hero estático con el mensaje de mayor valor comercial (ej. "único partner certificado en Argentina" — es la credencial más fuerte y diferenciada según `../competidores.md`), y mover el resto de los 9 mensajes a una sección de "por qué elegirnos" con scroll normal, no rotación automática.

### 3. Mobile: hero ocupa toda la pantalla antes de mostrar contenido (Media prioridad, mobile UX)
En 375px de ancho, el hero (imagen de fondo + texto + controles de carrusel) ocupa el 100% del viewport inicial (~812px de alto) antes de llegar a "Acerca de Psyware". Un visitante mobile debe hacer scroll completo sin ver ninguna prueba de valor concreta primero.
**Recomendación:** reducir el alto del hero en mobile y/o adelantar un indicador de scroll o CTA visible sin necesidad de scrollear.

### 4. Tono inconsistente: bloques en VERSALITA dentro de texto en oración (Baja prioridad, copy)
El texto "Psyware SSL es una empresa proveedora de soluciones de **INTELIGENCIA ARTIFICIAL**, comunicaciones militares..." mezcla mayúsculas de énfasis dentro de una oración en minúsculas normal. Leído por un lector (o por un lector de pantalla) suena a "gritado" y es inconsistente con el resto de la redacción, que es sobria.
**Recomendación:** usar negrita o color de acento en vez de mayúsculas para dar énfasis.

### 5. Icono de "cerebro con circuitos" genérico en sección de IA (Baja prioridad, AI Slop)
La ilustración de un perfil de cabeza humana con nodos/circuitos superpuestos (ver sección de IA en el home) es un recurso visual muy usado genéricamente para "representar IA" en stock art — no es un slop de gradiente/emoji clásico, pero cae en la misma categoría de iconografía genérica que no diferencia a Psyware de cualquier otra empresa de tecnología.
**Recomendación:** si se van a invertir recursos de diseño, priorizar esto por debajo de los puntos 1-3 (impacto menor).

### 6. Positivo: sin problemas de CSP detectados
A diferencia de Intelix, la consola de Psyware no mostró advertencias de CSP/X-Frame-Options — no se detectó el mismo problema de meta-tags mal usados en esta página. (No se verificaron las páginas internas en esta pasada.)

## Resumen de acciones tomadas en esta sesión
- [ ] Unificación de identidad visual con Intelix — cambio de branding grande, requiere decisión del usuario antes de tocar CSS de ambos sitios.
- [ ] Carrusel de 9 slides → hero estático — cambio de estructura de home, requiere decidir cuál es el mensaje principal; no aplicado en esta pasada por ser una decisión de contenido/negocio, no solo técnica.
- [ ] Hero mobile más compacto — pendiente, cambio de CSS acotado, candidato para próxima sesión.
- [x] Corregido el bloque en mayúsculas de "Acerca de Psyware" a formato con énfasis en negrita (ver commit).
- [ ] Icono de IA genérico — baja prioridad, no se tocó.
