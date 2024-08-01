import { LightningElement, track } from 'lwc';

export default class dtmSpinnerComponent extends LightningElement {
    @track mostrarSpinner = true; // Mostrar el spinner al cargar el componente
    spinnerClass = 'fullscreen-spinner'; // Agregar la clase CSS para que el spinner ocupe toda la pantalla

    connectedCallback() {
        setTimeout(() => {
            this.mostrarSpinner = false;
            this.spinnerClass = ''; // Eliminar la clase CSS para restaurar el tamaño normal del spinner
        }, 5000); // 5000 milisegundos = 5 segundos
    }
}