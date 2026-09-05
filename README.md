# 🛠️ FlashChip WinDriverTool v1.16

[Español](#español) | [English](#english)

---

<a name="español"></a>
## 🇪🇸 Español

**FlashChip WinDriverTool** es una solución automatizada modular diseñada para detectar, descargar e instalar controladores en sistemas Windows mediante un **sistema de búsqueda en 2 capas**.

### ⚙️ Estructura del Flujo de Instalación

* **🔹 Capa 1: Microsoft Update Native API (Motor Principal)**
  Consulta de forma directa el Catálogo Oficial de Microsoft Update a través de las APIs nativas del sistema. Resuelve entre el **90% y 95%** de los dispositivos sin requerir software de terceros.

* **🔹 Capa 2: Snappy Driver Installer CLI (Motor de Contingencia / Fallback)**
  Si tras la Capa 1 persisten dispositivos con errores (`ConfigManagerErrorCode -ne 0`), la herramienta invoca automáticamente **Snappy Driver Installer (SDI)** en modo desatendido por línea de comandos para instalar los controladores restantes.

---

<a name="english"></a>
## 🇬🇧 English

**FlashChip WinDriverTool** is a modular automated solution designed to detect, download, and install drivers on Windows systems using a **2-layer search system**.

### ⚙️ Installation Workflow

* **🔹 Layer 1: Microsoft Update Native API (Primary Engine)**
  Queries the official Microsoft Update Catalog directly via native system APIs. Resolves **90% to 95%** of missing devices without requiring third-party tools.

* **🔹 Layer 2: Snappy Driver Installer CLI (Contingency Engine / Fallback)**
  If unrecognized or faulty devices remain after Layer 1 (`ConfigManagerErrorCode -ne 0`), the tool automatically invokes **Snappy Driver Installer (SDI)** in unattended CLI mode to resolve the remaining hardware.

---

### 📌 Features / Características
* Automatic Administrator privilege elevation / Elevación automática de privilegios.
* Unattended search and installation / Búsqueda e instalación desatendida.
* Native execution policy bypass / Omisión nativa de restricciones de PowerShell.

---
by WoRFReD  
Canal: [FlashChip](https://youtube.com/@flashchiped)
---

### ☕ ¿Te ha sido útil este proyecto?
Si esta herramienta te ha servido de ayuda y quieres apoyar el desarrollo de nuevos scripts y proyectos para el canal:

[![Donate with PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg?logo=paypal)](https://paypal.me/WoRFReD)
