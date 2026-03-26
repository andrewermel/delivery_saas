import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = [
    'itemSelect',
    'priceInput',
    'suggestedPrice',
  ];

  connect() {
    this.itemsData = JSON.parse(
      this.element.dataset.itemsData || '[]'
    );
    // Set initial price if an item is already selected
    if (this.itemSelectTarget.value) {
      this.updatePrice();
    }
  }

  updatePrice() {
    const selectedItemId = parseInt(
      this.itemSelectTarget.value
    );
    const item = this.itemsData.find(
      i => i.id === selectedItemId
    );

    if (item && item.suggested_price) {
      const suggestedPrice = parseFloat(
        item.suggested_price
      ).toFixed(2);
      this.suggestedPriceTarget.textContent = `Sugerido: R$ ${suggestedPrice}`;
      this.priceInputTarget.value = suggestedPrice;
    } else {
      this.suggestedPriceTarget.textContent =
        'Sugerido: R$ --';
      this.priceInputTarget.value = '';
    }
  }
}
